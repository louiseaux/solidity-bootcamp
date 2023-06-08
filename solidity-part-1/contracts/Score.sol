// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Score {

    uint256 public score;
    address owner;

    event scoreSet(uint256 indexed);
    event userScoreSet(address, uint256);
    mapping(address => uint256) public scoreList;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if(msg.sender == owner){
            _;
        }
    }

    function setScore(uint256 _newScore) public onlyOwner {
        score = _newScore;
        emit scoreSet(_newScore);
    }

    function setUserScore(address _user, uint256 _newScore) public onlyOwner {
        scoreList[_user] = _newScore;
        emit userScoreSet(_user, scoreList[_user]);
    }
}