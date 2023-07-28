// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Storage {
    address public owner;
    uint256 public temperature;
    uint256 private nonce;

    event NumberStored(uint256 number);

    constructor() {
        owner = msg.sender;
        nonce = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Function to generate a pseudo-random number based on block and timestamp, restricted to a range (0 to 40)
    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, nonce))) % 41;
    }

    // Function to store a randomly generated number
    function storeRandomNumber() external onlyOwner {
        temperature = random();
        nonce++;
        emit NumberStored(temperature);
    }

    // Function to retrieve the stored random number
    function getStoredNumber() external view returns (uint256) {
        return temperature;
    }
}
