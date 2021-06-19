# Random Object Contract  
  
Short smart contract, written with deployment and tests for the Harmony network.  
  
Contract exists to return random object elements from an array of available objects. This is then mapped to an address to prove ownership.  
  
### Usage:  
  
Aslong as you have git, node and truffle installed, the following should work:  
  
```
git clone https://github.com/BadAtBlockchain/random_object_contract.git
cd random_object_contract
npm install

truffle compile -all
truffle migrate --network testnet
truffle test -- network testnet
```