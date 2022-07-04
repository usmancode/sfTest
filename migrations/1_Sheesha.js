const SFTestToken = artifacts.require('./SFTestToken.sol');
const SFTestNFT = artifacts.require('./SFTestNFT.sol');
const SFTestStaking = artifacts.require('./SFTestStaking.sol');
require('dotenv').config();

module.exports = async function (deployer) {

 await deployer.deploy(
   SFTestToken,
   process.env.Staking_Address,
   process.env.Amount
   );
 let token = await SFTestToken.deployed();

 await deployer.deploy(SFTestNFT);
 let nft = await SFTestNFT.deployed();

 await deployer.deploy(SFTestStaking, nft.address, token.address, process.env.Staking_Address);
 await SFTestStaking.deployed();

};

