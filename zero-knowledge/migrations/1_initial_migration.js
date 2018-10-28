var Migrations = artifacts.require("./Migrations.sol");
var Verifier = artifacts.require("./verifier.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Verifier);
};
