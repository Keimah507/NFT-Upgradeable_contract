require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');

module.exports = {
  networks: {
    // Add your network configuration here (e.g., localhost, Rinkeby, etc.)
  },
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};

