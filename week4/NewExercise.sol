// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Ownable} from"./Ownable.sol";

contract AddressBook is Ownable {

    struct Contact {
        uint256 id;
        string firstName;
        string lastName;
        uint256[] phoneNumbers;
    }

    Contact[] contacts;
    mapping(uint256 => uint256) idToIndex;
    mapping(uint256 => bool) contactExists;

    error ContactNotFound(uint256 _id);
    error ContactAlreadyExists(uint256 _id);

    constructor(address _initialOwner) Ownable(_initialOwner) {}

    function addContact(
            uint256 _id, 
            string calldata _firstName, 
            string calldata _lastName, 
            uint256[] calldata _phoneNumbers
        ) external onlyOwner {
            if (contactExists[_id]) {
                revert ContactAlreadyExists(_id);
            }
            idToIndex[_id] = contacts.length;
            contactExists[_id] = true;
            contacts.push(Contact(_id, _firstName, _lastName, _phoneNumbers));
    }

    function deleteContact(uint256 _id) external onlyOwner {
        if (!contactExists[_id]) {
            revert ContactNotFound(_id);
        }

        contactExists[_id] = false;
        delete contacts[idToIndex[_id]];
    }

    function getContact(uint256 _id) external view returns (Contact memory) {
        if (!contactExists[_id]) {
            revert ContactNotFound(_id);
        }
        
        return contacts[idToIndex[_id]];
    }

    function getAllContacts() external view returns (Contact[] memory) {
        uint256 _notDeleted = 0;
        for (uint256 i = 0; i < contacts.length; i++) {
            if (contactExists[contacts[i].id]) {
                _notDeleted++;
            }
        }
        Contact[] memory _result = new Contact[](_notDeleted);
        uint256 _index = 0;
        for (uint256 i = 0; i < contacts.length; i++) {
            if (contacts[i].phoneNumbers.length != 0) {
                _result[_index] = contacts[i];
                _index++;
            }
        }

        return _result;
    }
}

contract AddressBookFactory {
    function deploy() external returns (address) {
        AddressBook _book = new AddressBook(msg.sender);
        return address(_book);
    }
}