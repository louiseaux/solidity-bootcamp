// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract VolcanoCoin {

    uint256 public totalSupply;
    address owner;

    event supplyChange(uint256);
    event Transfer(address indexed, uint256);

    mapping(address => uint256) public balances;
    mapping(address => Payment[]) payments;

    struct Payment {
        address recipient;
        uint256 amount;
    }

    constructor() {
        totalSupply = 10000;
        owner = msg.sender;
        balances[msg.sender] = totalSupply;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You must be the owner");
        _;
    }

    function getSupply() public view returns(uint256) {
        return totalSupply;
    }

    function getPayments(address _account) public view returns(Payment[] memory) {
        return payments[_account];
    }

    function updateTotalSupply() public onlyOwner {
        totalSupply += 1000;
        emit supplyChange(totalSupply);
    }

    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        emit Transfer(_to, _amount);

        Payment memory payment;
        payment.recipient = _to;
        payment.amount = _amount;
        payments[msg.sender].push(payment);
    }
}