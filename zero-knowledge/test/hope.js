var Web3 = require("web3");
var ver = artifacts.require("verifier");

contract("Verifier", function(accounts) {
  // it("First Test", async function() {
  //   ver
  //     .deployed()
  //     .then(async function(instance) {
  //       //console.log(instance.getWeights);
  //       x = await instance.getWeights.call();
  //       //console.log("X: " + x);
  //       return x;
  //     })
  //     .then(function(weights) {
  //       console.log(weights[0].toNumber());
  //       console.log("SHIT");
  //       assert.equal(weights[0], 1, "Weights should be equal");
  //     });
  // });
  // it("should fail because function does not exist on contract", async function() {
  //   let v = await ver.deployed();
  //   try {
  //     await v.getWeights.call();
  //   } catch (e) {
  //     console.log(e.message);
  //     return e.message;
  //   }
  //   //throw new Error("I should never see this!");
  // });
  it("Set the Weights", async function() {
    let v = await ver.deployed();
    try {
      s = await v.setWeights.sendTransaction([3, 2, 3, 2, 2, 2]);
      console.log("Set: " + s);
      idk = await v.weights.call();
      console.log("Weights: " + idk);
    } catch (e) {
      console.log("Error: " + e.message);
      return e.message;
    }
    weights = await v.getWeights.call();
    //fuck = await v.weights2.call();
    //console.log("Array: " + fuck);
    console.log(weights[0].toNumber());
    assert.equal(weights[1].toNumber(), 2, "Weights should be 2");
    //throw new Error("I should never see this!");
  });
});
