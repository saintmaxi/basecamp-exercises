// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract FavoriteRecords {
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) userFavorites;

    error NotApproved(string _name);

    string[] initialApproved = [
        "Thriller",
        "Back in Black",
        "The Bodyguard",
        "The Dark Side of the Moon",
        "Their Greatest Hits (1971-1975)",
        "Hotel California",
        "Come On Over",
        "Rumours",
        "Saturday Night Fever"
    ];

    constructor() {
        for (uint256 i = 0; i < initialApproved.length; i++) {
            approvedRecords[initialApproved[i]] = true;
        }
    }

    function getApprovedRecords() external view returns (string[] memory) {
        string[] memory _approvedRecords = new string[](initialApproved.length);
        for (uint256 i = 0; i < initialApproved.length; i++) {
            _approvedRecords[i] = initialApproved[i];
        }
        return _approvedRecords;
    }

    function addRecord(string memory _record) external {
        if (!approvedRecords[_record]) {
            revert NotApproved(_record);
        }
        userFavorites[msg.sender][_record] = true;
    }

    function getUserFavorites(address _user) external view returns (string[] memory) {
        uint256 _totalFavorites = 0;
        for (uint256 i = 0; i < initialApproved.length; i++) {
            if (userFavorites[_user][initialApproved[i]]) {
                _totalFavorites++;
            }
        }
        string[] memory _userFavorites = new string[](_totalFavorites);
        uint256 index = 0;
        for (uint256 i = 0; i < initialApproved.length; i++) {
            if (userFavorites[_user][initialApproved[i]]) {
                _userFavorites[index] = initialApproved[i];
                index++;
            }
        }

        return _userFavorites;
    }

    function resetUserFavorites() external {
        for (uint256 i = 0; i < initialApproved.length; i++) {
        if (userFavorites[msg.sender][initialApproved[i]]) {
                userFavorites[msg.sender][initialApproved[i]] = false;
            }
        }
    }
}