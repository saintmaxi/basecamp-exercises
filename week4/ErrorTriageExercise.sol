// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract ErrorTriageExercise {
    /**
     * Finds the difference between each uint with it's neighbor (a to b, b to c, etc.)
     * and returns a uint array with the absolute integer difference of each pairing.
     */
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        uint[] memory results = new uint[](3);

        if (_a > _b) {
            results[0] = _a - _b;
        } else {
            results[0] = _b - _a;
        }

        if (_b > _c) {
            results[1] = _b - _c;
        } else {
            results[1] = _c - _b;
        }

        if (_c > _d) {
            results[2] = _c - _d;
        } else {
            results[2] = _d - _c;
        }

        return results;
    }

    /**
     * Found this example that is more elegant
     */

    // function diffWithNeighbor(
    //     uint256 _a,
    //     uint256 _b,
    //     uint256 _c,
    //     uint256 _d
    // ) public pure returns (uint256[] memory) {
    //     uint256[] memory results = new uint256[](3);

    //     results[0] = abs(int256(_a) - int256(_b));
    //     results[1] = abs(int256(_b) - int256(_c));
    //     results[2] = abs(int256(_c) - int256(_d));

    //     return results;
    // }

    // function abs(int256 x) private pure returns (uint256) {
    //     return x >= 0 ? uint256(x) : uint256(-x);
    // }

    error InvalidBase(uint _base);
    error InvalidModifier(int _base);

    /**
     * Changes the _base by the value of _modifier.  Base is always >= 1000.  Modifiers can be
     * between positive and negative 100;
     */
    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint) {
        if (_base < 1000) {
            revert InvalidBase(_base);
        }
        if (_modifier > 100 || _modifier < -100) {
            revert InvalidModifier(_modifier);
        }
        if (_modifier >= 0) {
            return _base + uint(_modifier);
        } else {
            return _base - uint(-_modifier);
        }
    }

    /**
     * Pop the last element from the supplied array, and return the popped
     * value (unlike the built-in function)
     */
    uint[] arr;
    error ArrayEmpty();

    function popWithReturn() public returns (uint) {
        if (arr.length == 0) {
            revert ArrayEmpty();
        }
        uint lastElement = arr[arr.length - 1];
        arr.pop();
        return lastElement;
    }

    // The utility functions below are working as expected
    function addToArr(uint _num) public {
        arr.push(_num);
    }

    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function resetArr() public {
        delete arr;
    }
}
