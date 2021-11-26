const NewContract = artifacts.require("./contracts/NewContract.sol");

module.exports = function(deployer) {
    deployer.deploy(NewContract);
};