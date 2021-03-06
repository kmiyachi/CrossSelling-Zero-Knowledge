App = {
  web3Provider: null,
  contracts: {},
  proofs: {},
  init: function() {
    // Load users.
    jQuery.getJSON("../users.json", function(data) {
      var usersRow = $("#usersRow");
      var userTemplate = $("#userTemplate");

      for (i = 0; i < data.length; i++) {
        userTemplate.find(".panel-title").text(data[i].name);
        userTemplate.find(".id").text(data[i].id);
        userTemplate.find(".vip").attr("data-vip", data[i].id);
        userTemplate.find(".btn-calc").attr("data-id", data[i].id);
        //userTemplate.find(".btn-calc").attr("data-vip", data[i].VIP);
        usersRow.append(userTemplate.html());
      }
    });
    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there an injected web3 instance?
    if (typeof web3 !== "undefined") {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider(
        "http://localhost:8545"
      );
    }
    web3 = new Web3(App.web3Provider);
    App.initProofs();
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("Verifier.json", function(data) {
      console.log(data);
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var VIPArtifact = data;

      App.contracts.Verifier = TruffleContract(VIPArtifact);
      // Set the provider for our contract
      App.contracts.Verifier.setProvider(App.web3Provider);
      // Use our contract to retrieve and mark the adopted users
      console.log(App.contracts.Verifier);
      //return App.updateVIP();
    });

    return App.bindEvents();
  },
  initProofs: function() {
    jQuery.getJSON("../hope.json", function(data) {
      console.log(data);
      proof_obj = jQuery.parseJSON(data);
      proofs = proof_obj;
      console.log(proofs);
    });
    return proofs;
  },

  bindEvents: function() {
    $(document).on("click", ".btn-calc", App.handleAdopt);
  },

  updateVIP: function(id, vip, account) {
    var VIPInstance;
    App.contracts.Verifier.deployed()
      .then(function(instance) {
        VIPInstance = instance;
        console.log(VIPInstance);
        var p = proofs[id];
        VIPInstance.verifyTx.sendTransaction(...p, [id, vip]).then(console.log);
        return VIPInstance.verifyTx.call(...p, [id, vip]);
      })
      .then(function(score) {
        console.log("SCORE: " + score);
        $(".panel-user")
          .eq(id - 1)
          .find("span")
          .text(score)
          .attr("disabled", true);
      })
      .catch(function(err) {
        console.log(err.message);
      });
  },

  handleAdopt: function(event) {
    event.preventDefault();
    console.log("BUTTON WAS PRESSED");
    var userId = parseInt($(event.target).data("id"));
    var vipScore = $(`input[data-vip='${userId}']`).val();
    console.log(vipScore);
    //var vipScore = parseInt($(event.target).data("vip"));
    console.log(vipScore);
    var VIPInstance;
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      console.log(account);
      App.contracts.Verifier.deployed()
        .then(function(instance) {
          VIPInstance = instance;
          // Execute adopt as a transaction by sending account
          console.log("user ID: " + userId);
          console.log("Instance: " + instance);
          return [userId, vipScore];
        })
        .then(function(io) {
          return App.updateVIP(io[0], io[1]);
        })
        .catch(function(err) {
          console.log("ERROR: " + err.message);
        });
    });
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
