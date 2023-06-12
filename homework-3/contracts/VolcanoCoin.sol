// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract VolcanoCoin {

    uint256 totalSupply = 10000;
    address owner;

    event SupplyChange(uint256 indexed);
    event Transfer(address, address, uint256);

    mapping(address => uint256) private balance;
    mapping(address => Payment[]) private payments;

    struct Payment {
        address recipient;
        uint256 amount;
    }

    constructor() {
        owner = msg.sender;
        balance[owner] = totalSupply;
    }

    modifier onlyOwner {
        if(msg.sender == owner) {
            _;
        }
    }

    function getSupply() public view returns(uint256) {
        return totalSupply;
    }
    
    function getBalance(address _account) public view returns(uint256) {
        return balance[_account];
    }

    function getPayments(address _account) public view returns(Payment[] memory) {
        return payments[_account];
    }

    function addSupply() public onlyOwner {
        totalSupply += 1000;
        emit SupplyChange(totalSupply);
    }

    function transfer(address _to, uint256 _amount) public {
        require(_amount > 0, "Amount must be > 0");

        uint256 fromBalance = getBalance(msg.sender);
        require(fromBalance >= _amount, "Transfer amount exceeds balance");

        balance[msg.sender] = fromBalance - _amount;
        balance[_to] += _amount;

        payments[msg.sender].push(Payment({recipient:_to, amount:_amount}));

        emit Transfer(msg.sender, _to, _amount);
    }
}