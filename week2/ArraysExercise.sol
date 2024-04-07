// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract ArraysExercise {
    uint256[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    address[] senders;
    uint[] timestamps;

    function getNumbers() public view returns (uint256[] memory) {
        return numbers;
    }

    function resetNumbers() public {
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    function appendToNumbers(uint[] calldata _nums) public {
        for (uint i = 0; i < _nums.length; ++i) {
            numbers.push(_nums[i]);
        }
    }

    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    function afterY2K() public view returns (uint[] memory, address[] memory) {
        uint resultArrayLength = 0;
        for (uint i = 0; i < timestamps.length; ++i) {
            if (timestamps[i] > 946702800) {
                ++resultArrayLength;
            }
        }
        uint[] memory timeResult = new uint[](resultArrayLength);
        address[] memory senderResult = new address[](resultArrayLength);
        uint index = 0;
        for (uint i = 0; i < timestamps.length; ++i) {
            if (timestamps[i] > 946702800) {
                timeResult[index] = timestamps[i];
                senderResult[index] = senders[i];
                ++index;
            }
        }

        return (timeResult, senderResult);
    }

    function resetSenders() public {
        delete senders;
    }

    function resetTimestamps() public {
        delete timestamps;
    }
}