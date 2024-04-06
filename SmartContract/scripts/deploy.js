(async () => {
  try {
    const AdMarket = await hre.ethers.getContractFactory("AdMarket.sol");
    const AdMarketInstance = await AdMarket.deploy();

    await AdMarketInstance.deployed();

    console.log(`Deployed contract at ${AdMarketInstance.address}`);
  } catch (err) {
    console.error(err);
    process.exitCode = 1;
  }
})();
