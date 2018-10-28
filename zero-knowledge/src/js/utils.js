const ethers = require("ethers");
const chalk = require("chalk");
const Web3 = require("web3");
var _ = require("lodash");
var Promise = require("bluebird");
solc = require("solc");
fs = require("fs");
var Verifier = artifacts.require("verifier");

web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
//web3.eth.getAccounts().then(console.log);
//code = fs.readFileSync("./contracts/verifier.sol").toString();
console.log(Verifier.address);
module.exports = async exit => {
};
