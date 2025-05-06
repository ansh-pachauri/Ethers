import { JsonRpcProvider, id } from "ethers";

const provider = new JsonRpcProvider("https://eth-mainnet.g.alchemy.com/v2/oGFW5iZ7O1uBxw0whcYE6C8oSS4Y8gSJ");

async function pollBack(blockNumber: number){
    const log = await provider.getLogs({
        address: "0xdac17f958d2ee523a2206206994597c13d831ec7",
        fromBlock: blockNumber,
        toBlock: blockNumber + 2,
        topics: [id("Transfer(address,address,uint256)")]
    });

    console.log(log);
}

pollBack(21493826);



