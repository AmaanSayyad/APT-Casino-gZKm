import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.27",
      networks: {
        ZytronTestnet: {
          url: "https://rpc-testnet.zypher.network/",
          chainId: 50098,
          accounts: ["0xYOUR_PRIVATE_KEY"], // Add your private key here
        },
        B2Testnet: {
          url: "https://rpc.ankr.com/b2_testnet/",
          chainId: 1123,
          accounts: ["0xYOUR_PRIVATE_KEY"], // Add your private key here
        },
    },
};

export default config;