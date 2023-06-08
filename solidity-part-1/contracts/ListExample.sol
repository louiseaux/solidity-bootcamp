// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract ListExample {

    struct DataStruct {
        address userAddress;
        uint256 userID;
    }

    DataStruct[] public records;

    function createRecord1(address _userAddress, uint256 _userID) public pure {
        DataStruct memory newRecord;
        newRecord.userAddress = _userAddress;
        newRecord.userID      = _userID;
    }

    function createRecord2(address _userAddress, uint256 _userID) public {
        records.push(DataStruct({userAddress:_userAddress,userID:_userID}));
    }

    function getRecordCount() public view returns(uint256 recordCount) {
        return records.length;
    }
}