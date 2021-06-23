// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SuperRareToken {
    uint8 public supply;
    string public name;
    string public symbol;

    struct DataObj {
        string URL;
    }

    DataObj[] private allTokens;
    uint8 totalMinted;
    mapping (uint => address) owners;

    event MintData(uint8 totalTokens, uint8 availableTokens, uint8 totalMinted, uint256 randomIndex);

    constructor() {
        name = "Super Rare Token!";
        symbol = "SRT";
        supply = 100;
        totalMinted = 0;

        for (uint8 i = 0; i < supply; i++) {
            DataObj memory newData = DataObj("https://some.url");
            allTokens.push(newData);
        }
    }

    function mint() public payable returns (uint256) {
        require(totalMinted < supply, "All tokens minted");

        // horrible but may be required to get a value for the following array?
        uint8 count = 0;
        for (uint8 i = 0; i < supply; i++) {
            if (owners[i] == address(0)) {
                count++;
            }
        }

        uint8[] memory availableTokens = new uint8[](count);

        // first get all objects that are not owned
        uint8 loopTracker = 0;
        for (uint8 i = 0; i < supply; i++) {
            if (owners[i] == address(0)) {
                availableTokens[loopTracker] = i; // i is the available token ID from the overall array
                loopTracker++; // loop tracker maintains our position in the availableTokens array
            }
        }

        // 'count' should still be our length of available tokens
        require(count == (supply - totalMinted), "available count does not equal (supply-minted)");

        uint randHash = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        uint256 selection = randHash % count;

        require(owners[selection] == address(0), "Token is already owned?! Failed");

        // increment the total minted and assign the token to the new owner (sender)
        totalMinted++;
        owners[selection] = msg.sender;

        emit MintData(supply, count, totalMinted, selection);

        return selection;
    }

    // exposed utility for users
    function totalAvailable() public view returns (uint8) {
        return supply - totalMinted;
    }

    function ownerOf(uint _tokenId) public view returns (address){
        // we make sure it's less than supply, as our tokenID's start at 0 in this project
        // to start from one, we must do "owners[selection+1] = msg.sender" in the mint function
        require(_tokenId < supply, "token must be less than supply (n-1)");
        require(owners[_tokenId] != address(0), "token is not owned by anyone yet");

        return owners[_tokenId];
    }

    // note, this will probably look horrible
    function balanceOf(address _address) public view returns (uint8) {
        require(_address != address(0), "Cannot check balance of 0x0");

        return _balanceOf(_address);
    }

    function _balanceOf(address _address) private view returns (uint8) {
        uint8 total = 0;

        for (uint8 i = 0; i < supply; i++) {
            if (owners[i] != address(0)) {
                if (owners[i] == _address) {
                    total++;
                }
            }
        }

        return total;
    }

    function inventory(address _address) public view returns (uint8[] memory) {
        require(_address != address(0), "Cannot get inventory of 0x0");
        
        uint8 bal = _balanceOf(_address);
        uint8[] memory tokens = new uint8[](bal);

        if (bal > 0) {
            uint8 ticker = 0;

            // seems weird to loop here again although we already did in _balanceOf, change?
            for (uint8 i = 0; i < supply; i++) {
                if (owners[i] == _address) {
                    tokens[ticker] = i;
                    ticker++;
                }
            }
            return tokens;
        } else {
            return tokens;
        }
    }

    function tokenDataUrl(uint _tokenId) public view returns (string memory) {
        require(_tokenId < supply, "Token is not with mintable range");
        require(owners[_tokenId] != address(0), "Token has not been minted");

        return allTokens[_tokenId].URL;
    }
}