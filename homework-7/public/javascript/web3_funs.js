const Web3 = require('web3');
const fs = require('fs');

// Set variables here for reuse
const ownerPub = process.env.OWNER_PUB;
const erc721Address = "0xEf2d5617d9e8cdb968a2f9A44E5E42C38355f140";

let web3;
let encodeNft;
async function init() {
    // Smart contract ABI
    const contract = JSON.parse(fs.readFileSync('./build/contracts/EncodeToken.json', 'utf8'));
    const nftAbi = contract.abi;
    // Initialise web3 library
    web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

    // Add credentials
    web3.eth.accounts.wallet.add({
        privateKey: process.env.OWNER_PRIV,
        address: ownerPub
    });

    // Initialise contract
    encodeNft = new web3.eth.Contract(nftAbi, erc721Address);

    console.log("Web3 connection initialised.")
}

const web3Funs = {
    async mintNft(params) {
        const _rx = params.receiver || ownerPub;
        try {
            const mint = await encodeNft.methods
                .mintToken(_rx, params.uri)
                .send({ from: ownerPub, gas: 500000 });
            return { 0: mint.transactionHash };
        } catch (e) {
            console.log(e.toString())
        }
    },
    async getNfts(address) {
        try {

            const nfts = await encodeNft.methods
                .getNfts(address).call();
            let nftArr = [];
            for (const tokenId of nfts) {
                nftArr.push({ [tokenId]: await web3Funs.getUri(tokenId) });
            }
            return { 0: nftArr }
        } catch (e) {
            console.log(e.toString())
        }
    },
    async getUri(tokenId) {
        try {
            const uri = await encodeNft.methods
                .tokenURI(tokenId).call();
            return await uri;
        } catch (e) {
            console.log(e.toString())
        }
    },
    async transferNft(params) {
        console.log(params)
        try {
            const transfer = await encodeNft.methods
                .transferNft(params.from, params.to, params.tokenId)
                .send({ from: ownerPub, gas: 500000 });
            return { 0: transfer.transactionHash };
        } catch (e) {
            console.log(e.toString())
        }
    }
}
init();

module.exports = web3Funs;