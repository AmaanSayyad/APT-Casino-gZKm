"use client";
import { http } from "wagmi";
import {
  mainnet,
  polygon,
  zytronChain,
  b2Chain
} from "wagmi/chains";
import {
  getDefaultConfig,
} from "@rainbow-me/rainbowkit";
const projectId = `64df6621925fa7d0680ba510ac3788df`;

export const zytronChain = {
  id: 50098,
  name: "Zytron Testnet",
  nativeCurrency: { name: "Zytron Testnet", symbol: "ETH", decimals: 18 },
  rpcUrls: {
    default: { http: ["https://rpc-testnet.zypher.network"] },
  },
  blockExplorers: {
    default: { name: "Zytron Testnet", url: "" },
  },
};
const supportedChains = [mainnet, polygon, zytronChain, b2Chain];
export const config = getDefaultConfig({
  appName: "PowerPlay",
  projectId,
  multiInjectedProviderDiscovery: false,
  chains: supportedChains,
  ssr: true,
  transports: supportedChains.reduce(
    (obj, chain) => ({ ...obj, [chain.id]: http() }),
    {}
  ),
});
