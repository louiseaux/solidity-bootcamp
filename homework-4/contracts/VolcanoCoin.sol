// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoCoin is ERC20("Volcano Coin", "VLC"), Ownable {

    uint256 constant initialSupply = 10000;

    struct Payment {
        address recipient;
        uint256 amount;
    }

    mapping(address => Payment[]) public payments;
    event supplyChange(uint256);

    constructor() {
        _mint(msg.sender, initialSupply);
    }

    function getPayments(address _account) public view returns (Payment[] memory) {
        return payments[_account];
    }

    function addPaymentRecord(address _sender, address _recipient, uint256 _amount) internal {
        payments[_sender].push(Payment(_recipient, _amount));
    }

    function addTotalSupply(uint256 _amount) public onlyOwner {
        _mint(msg.sender, _amount);
        emit supplyChange(_amount);
    }

    function transfer(address _recipient, uint256 _amount) public virtual override returns (bool) {
        _transfer(msg.sender, _recipient, _amount);
        addPaymentRecord(msg.sender, _recipient, _amount);
        return true;
    }
}