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
        uint randHash = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        uint256 selection = randHash % count;

        require(owners[selection] == address(0), "Token is already owned?! Failed");

        // increment the total minted and assign the token to the new owner (sender)
        totalMinted++;
        owners[selection] = msg.sender;

        emit MintData(supply, count, totalMinted, selection);

        return selection;
    }
}