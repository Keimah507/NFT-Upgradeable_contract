const { ethers, upgrades } = require('hardhat');

async function deployNFTmintV2() {
    const [deployer] = await ethers.getSigners();

    // Replace 'NFTmintV2' with the name of your new contract version
    const NFTmintV2 = await ethers.getContractFactory('NFTmintV2');
    
    // Deploy the new version of the contract
    const nftMintV2 = await upgrades.deployProxy(NFTmintV2, [deployer.address]);

    // Wait for the deployment to complete
    await nftMintV2.deployed();

    console.log('NFTmintV2 deployed to:', nftMintV2.address);
}

deployNFTmintV2()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });