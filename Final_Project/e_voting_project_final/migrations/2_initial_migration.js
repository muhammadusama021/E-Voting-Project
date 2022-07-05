const Election = artifacts.require("Election");

module.exports = function (deployer) {
  deployer.deploy(Election,"0xA3385511a42A84986Cd2A399Aee7060fBa979058","Admin");
};
