/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-ethers");
require('hardhat-abi-exporter');

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  const provider = hre.ethers.provider;

  for (const account of accounts) {
    console.log(
      "%s (%i ETH)",
      account.address,
      hre.ethers.utils.formatEther(
        // getBalance returns wei amount, format to ETH amount
        await provider.getBalance(account.address)
      )
    );
  }
});

abiExporter: [
  {
    path: './abi/json',
    format: "json",
  },
  {
    path: './abi/minimal',
    format: "minimal",
  },
  {
    path: './abi/fullName',
    format: "fullName",
  },
]

module.exports = {
  solidity: "0.8.19",
  networks: {
    hardhat: {
      chainId: 1337, // default is 31337
    },
  }
};