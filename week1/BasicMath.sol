// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract BasicMath {

    function adder(uint256 _a, uint256 _b) external pure returns (uint256, bool) {
        uint256 sum;
        unchecked {
            sum = _a + _b;
        }
        bool error = sum < _a || sum < _b;
        if (error) sum = 0;
        return (sum, error);
    }
    
    function subtractor(uint256 _a, uint256 _b) external pure returns (uint256, bool) {
        if (_b > _a) {
            return (0, true);
        } else {
            return (_a - _b, false);
        }
    }
}