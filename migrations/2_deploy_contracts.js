const SuperRareToken = artifacts.require("SuperRareToken");

module.exports = function(deployer) {
  deployer.deploy(SuperRareToken);
};
