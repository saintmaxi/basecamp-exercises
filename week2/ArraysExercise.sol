// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract ArraysExercise {
    uint256[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    address[] senders;
    uint256[] timestamps;

    function getNumbers() public view returns (uint256[] memory) {
        return numbers;
    }

    function resetNumbers() public {
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    function appendToNumbers(uint256[] calldata _nums) public {
        for (uint256 i = 0; i < _nums.length; ++i) {
            numbers.push(_nums[i]);
        }
    }

    function saveTimestamp(uint256 _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    function afterY2K() public view returns (uint256[] memory, address[] memory) {
        uint256 resultArrayLength = 0;
        for (uint256 i = 0; i < timestamps.length; ++i) {
            if (timestamps[i] > 946702800) {
                ++resultArrayLength;
            }
        }
        uint256[] memory timeResult = new uint256[](resultArrayLength);
        address[] memory senderResult = new address[](resultArrayLength);
        uint256 index = 0;
        for (uint256 i = 0; i < timestamps.length; ++i) {
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