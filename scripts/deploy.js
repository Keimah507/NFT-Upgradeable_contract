const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();

    const NFTmint = await hre.ethers.getContractFactory("NFTmint");
    const nftMint = await upgrades.deployProxy(NFTmint, [deployer.address]);
    await nftMint.deployed();

    console.log("NFTmint deployed to:", nftMint.address);

    const NFTmintProxy = await hre.ethers.getContractFactory("NFTmintProxy");
    const nftMintProxy = await NFTmintProxy.deploy(nftMint.address, deployer.address, "0x");
    await nftMintProxy.deployed();

    console.log("NFTmintProxy deployed to:", nftMintProxy.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });