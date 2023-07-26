const EncodeToken = artifacts.require("EncodeToken");

module.exports = function(deployer) {
  deployer.deploy(EncodeToken);
};
