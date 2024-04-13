// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract GarageManager {
    struct Car {
        string make;
        string model;
        string color;
        uint256 doors;
    }

    mapping (address => Car[]) public garage;

    error BadCarIndex(uint256 _index);

    function addCar(
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint256  _doors
    ) external {
        Car memory _userCar = Car(_make, _model, _color, _doors);
        garage[msg.sender].push(_userCar);
    }

    function getMyCars() external view returns (Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address _addr) external view returns (Car[] memory) {
        return garage[_addr];
    }

    function updateCar(
        uint256 _index, 
        string calldata _make, 
        string calldata _model, 
        string calldata _color, 
        uint256 _doors
        ) external {
            if (_index > garage[msg.sender].length - 1) {
                revert BadCarIndex(_index);
            }
            garage[msg.sender][_index] = Car(_make, _model, _color, _doors);
    }

    function resetMyGarage() external {
        delete garage[msg.sender];
    }
}
