require("@nomicfoundation/hardhat-toolbox");

const fs = require("fs");
let mnemonic = fs.readFileSync(".secret").toString().trim();
let infuraProjectID = fs.readFileSync(".infura").toString().trim();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    // ganache: {
    //   host: "127.0.0.1",
    //   port: 8545,
    //   network_id: "*",
    // },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${infuraProjectID}`,
      accounts: {
        mnemonic: "mnemonic", // Replace with your mnemonic phrase
        path: "m/44'/137'/0'/0", // Updated path for Ethereum
        initialIndex: 0,
        count: 20,
      },
    },
  },
};
