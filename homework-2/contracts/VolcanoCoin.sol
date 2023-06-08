// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract VolcanoCoin {

    uint256 supply = 10000;
    address owner;

    event supplyChange(uint256 indexed);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if(msg.sender == owner) {
            _;
        }
    }

    function getSupply() public view returns(uint256) {
        return supply;
    }

    function addSupply() public onlyOwner {
        supply += 1000;
        emit supplyChange(supply);
    }
}