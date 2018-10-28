App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    // Load pets.
    jQuery.getJSON("../users.json", function(data) {
      var petsRow = $("#petsRow");
      var petTemplate = $("#petTemplate");

      for (i = 0; i < data.length; i++) {
        petTemplate.find(".panel-title").text(data[i].name);
        petTemplate.find(".id").text(data[i].id);
        petTemplate.find(".vip").text(data[i].VIP);
        petTemplate.find(".btn-calc").attr("data-id", data[i].id);
        petsRow.append(petTemplate.html());
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
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("VIP_Level.json", function(data) {
      console.log(data);
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var VIPArtifact = data;

      App.contracts.VIP_Level = TruffleContract(VIPArtifact);
      // Set the provider for our contract
      App.contracts.VIP_Level.setProvider(App.web3Provider);
      // Use our contract to retrieve and mark the adopted pets
      console.log(App.contracts.VIP_Level);
      //return App.updateVIP();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on("click", ".btn-calc", App.handleAdopt);
  },

  updateVIP: function(id, account) {
    var VIPInstance;
    App.contracts.VIP_Level.deployed()
      .then(function(instance) {
        VIPInstance = instance;
        console.log(VIPInstance);
        return VIPInstance.calculate_VIP.call(id);
      })
      .then(function(score) {
        console.log("SCORE: " + score);
        $(".panel-pet")
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
    var petId = parseInt($(event.target).data("id"));
    var VIPInstance;
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      App.contracts.VIP_Level.deployed()
        .then(function(instance) {
          VIPInstance = instance;
          // Execute adopt as a transaction by sending account
          console.log("PET ID: " + petId);
          console.log("Instance: " + instance);
          VIPInstance.addUser("NEW", { from: account }).then(console.log);
          //return VIPInstance.getUser(petId, { from: account });
          return petId;
        })
        .then(function(id) {
          return App.updateVIP(id);
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
