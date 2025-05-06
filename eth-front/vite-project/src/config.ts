import { http, createConfig } from 'wagmi'
import { mainnet } from 'wagmi/chains'
import { injected } from 'wagmi'

//injected is a connector that allows you to connect to the wallet injected into the browser (like MetaMask)

export const config = createConfig({
   connectors:[injected()],
  chains: [mainnet],
	  transports: {
	    [mainnet.id]: http("https://eth-mainnet.g.alchemy.com/v2/oGFW5iZ7O1uBxw0whcYE6C8oSS4Y8gSJ"),
  },
})