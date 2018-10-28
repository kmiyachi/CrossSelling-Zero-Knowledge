var VIP = artifacts.require("./VIP_Level.sol");
var Adoption = artifacts.require("Adoption");

module.exports = function(deployer) {
  deployer.deploy(VIP);
  deployer.deploy(Adoption);
};
