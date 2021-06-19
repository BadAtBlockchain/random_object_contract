const { assert } = require("chai");

const SuperRareToken = artifacts.require("SuperRareToken");

contract('SuperRareToken', (accounts) => {
  let superRareToken;

  before(async () => {
    superRareToken = await SuperRareToken.deployed();
  })

  it('should mint', async () => {
    // attempting to mint
    result = await superRareToken.mint();
    var args = result.logs[0].args;
    console.log(args);
    console.log("Result: " + args.randomIndex.toNumber());
  });

  it('should mint 5', async () => {
    for (var i = 0; i < 5; i++) {
      console.log("Attempt: " + (i + 1).toString());
      result = await superRareToken.mint();
      var args = result.logs[0].args;
      console.log("Total Supply: " + args.totalTokens.toNumber());
      console.log("Available Tokens: " + args.availableTokens.toNumber());
      console.log("Total minted: " + args.totalMinted.toNumber());
      console.log("Random Index: " + args.randomIndex.toNumber());
      console.log("");
    }
  });
});