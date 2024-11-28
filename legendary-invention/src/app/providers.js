"use client";
import { DynamicContextProvider } from "@dynamic-labs/sdk-react-core";
import { EthereumWalletConnectors } from "@dynamic-labs/ethereum";
import { DynamicWagmiConnector } from "@dynamic-labs/wagmi-connector";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { mainnet } from "viem/chains";
import { createConfig, WagmiProvider,http } from "wagmi";
const zytronChain = {
  id: 50098,
  name: "Zytron Testnet",
  nativeCurrency: { name: "Zytron Testnet", symbol: "ETH", decimals: 18 },
  rpcUrls: {
    default: { http: ["https://rpc-testnet.zypher.network"] },
  },
  blockExplorers: {
    default: { name: "Testnet", url: "" },
  },
};
const evmNetworks = [
  {
    blockExplorerUrls: [""],
    chainId: 50098,
    chainName: "Zytron Testnet",
    iconUrls: ["https://app.dynamic.xyz/assets/networks/eth.svg"],
    name: "Zytron",
    nativeCurrency: {
      decimals: 18,
      name: "Zytron Testnet",
      symbol: "ETH",
      iconUrl: "https://app.dynamic.xyz/assets/networks/eth.svg",
    },
    networkId: 50098,
    rpcUrls: [""],
    vanityName: "Zytron Testnet",
  },
  {
    blockExplorerUrls: [''],
    chainId: 1123,
    chainName: 'B2 Testnet',
    iconUrls: ['https://app.dynamic.xyz/assets/networks/btc.svg'],
    name: 'B2',
    nativeCurrency: {
      decimals: 18,
      name: 'Bitcoin',
      symbol: 'BTC',
      iconUrl: 'https://app.dynamic.xyz/assets/networks/btc.svg',
    },
    networkId: 1123,

    rpcUrls: ['https://rpc.ankr.com/b2_testnet'],
    vanityName: 'B2 Testnet',
  },
{
    blockExplorerUrls: ['https://etherscan.io/'],
    chainId: 5,
    chainName: 'Ethereum Goerli',
    iconUrls: ['https://app.dynamic.xyz/assets/networks/eth.svg'],
    name: 'Ethereum',
    nativeCurrency: {
      decimals: 18,
      name: 'Ether',
      symbol: 'ETH',
      iconUrl: 'https://app.dynamic.xyz/assets/networks/eth.svg',
    },
    networkId: 5,
    rpcUrls: ['https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'],

    vanityName: 'Goerli',
  },
  {
    blockExplorerUrls: ['https://polygonscan.com/'],
    chainId: 137,
    chainName: 'Matic Mainnet',
    iconUrls: ["https://app.dynamic.xyz/assets/networks/polygon.svg"],
    name: 'Polygon',
    nativeCurrency: {
      decimals: 18,
      name: 'MATIC',
      symbol: 'MATIC',
      iconUrl: 'https://app.dynamic.xyz/assets/networks/polygon.svg',
    },
    networkId: 137,
    rpcUrls: ['https://polygon-rpc.com'],
    vanityName: 'Polygon',
  },
];
const queryClient = new QueryClient();
const config = createConfig({
  chains: [mainnet, zytronChain, b2Chain],
  multiInjectedProviderDiscovery: false,
  transports: {
    [mainnet.id]: http(),
    [zytronChain.id]: http(),
  },
});
export default function Providers({ children }) {
  return (
    <DynamicContextProvider
      settings={{
        environmentId: "e2e630bf-3356-4dca-b0b9-71537b67ccf6",
        walletConnectors: [EthereumWalletConnectors],
        overrides: { evmNetworks },
      }}
    >
      <WagmiProvider config={config}>
        <QueryClientProvider client={queryClient}>
          <DynamicWagmiConnector>{children}</DynamicWagmiConnector>
        </QueryClientProvider>
      </WagmiProvider>
    </DynamicContextProvider>
  );
}
