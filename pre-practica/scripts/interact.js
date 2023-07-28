const Web3 = require('web3');
const contractABI = [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "number",
				"type": "uint256"
			}
		],
		"name": "NumberStored",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "getStoredNumber",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "storeRandomNumber",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "temperature",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]; // ABI of your contract
const contractAddress = 0x56b5d6ffa3Ac500a6F1EFADfcf5e42bF85789FB6; // Address of your deployed contract
const ethereumNodeURL = 'https://mainnet.infura.io/v3/25d3ec3b6b304ecbb84ad36022932eae'; // Replace with your Ethereum node URL

const web3 = new Web3(ethereumNodeURL);

const contract = new web3.eth.Contract(contractABI, contractAddress);

async function getStoredNumber() {
  try {
    const value = await contract.methods.getStoredNumber().call();
    console.log('Stored Number:', parseInt(value, 10));
  } catch (error) {
    console.error('Error:', error);
  }
}

getStoredNumber();
