// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./SillyStringUtils.sol";

contract ImportsExercise {
    SillyStringUtils.Haiku public haiku;

    function saveHaiku(string calldata _input1, string calldata _input2, string calldata _input3) external {
        haiku = SillyStringUtils.Haiku(_input1, _input2, _input3);
    }

    function getHaiku() external view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    function shruggieHaiku() external view returns (SillyStringUtils.Haiku memory) {
        return SillyStringUtils.Haiku(haiku.line1, haiku.line2, SillyStringUtils.shruggie(haiku.line3));
    }
}