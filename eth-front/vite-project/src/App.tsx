import { useAccount, useConnect, useDisconnect, useReadContract, WagmiProvider } from 'wagmi';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { config } from './config';

import './App.css'
import { AllowUSDT } from './AllowUSDT';

const client = new QueryClient();

function App() {
  

  return (
    <>
    <WagmiProvider config={config}>
      <QueryClientProvider client={client}>
        <ConnectWallet />
        <TotalSupply />
        <AllowUSDT />
      </QueryClientProvider>
    </WagmiProvider>
      
    </>
  )
}

function TotalSupply() {
  const {data, isLoading} = useReadContract({
    address: '0xdac17f958d2ee523a2206206994597c13d831ec7',
    abi: [
        {
        "constant": true,
        "inputs": [],
        "name": "totalSupply",
        "outputs": [
            {
            "name": "",
            "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
        }
    ],
    functionName: 'totalSupply',
  })

  if(isLoading){
    return (
      <div>
        Loading...
      </div>
    )
  }

  return (
    <div>
      TotalSupply: {data?.toString()}
    </div>
  )
}

function ConnectWallet() {
  const { connectors } = useConnect();
  const {address} = useAccount();
  const {disconnect} = useDisconnect();
  const {connect} = useConnect();

  if(address){
    return(
<div className='flex flex-col items-center justify-center'>
    Your address is {address}
    <button onClick={() => disconnect()}>Disconnect</button>
    </div>
    )
    
  }

  return (
    

      <div className='flex flex-col items-center justify-center'>
        {connectors.map((connector) => (
          <button
          className='flex flex-col items-center'
          key={connector.id} onClick={() =>
          {connect({
            connector: connector
          })}}>
            Connect via {connector.name}
          </button>
        ))}
      </div>
  )
}

export default App


