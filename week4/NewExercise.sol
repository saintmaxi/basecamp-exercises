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

    error ContactNotFound(uint256 _id);

    constructor(address _initialOwner) Ownable(_initialOwner) {}

    function addContact(
            uint256 _id, 
            string calldata _firstName, 
            string calldata _lastName, 
            uint256[] calldata _phoneNumbers
        ) external onlyOwner {
        Contact memory _newContact = Contact(_id, _firstName, _lastName, _phoneNumbers);
        contacts.push(_newContact);
    }

    function deleteContact(uint256 _id) external onlyOwner {
        for (uint256 i = 0; i < contacts.length; i++) {
            if (contacts[i].id == _id) {
                delete contacts[i];
                return;
            }
        }
        revert ContactNotFound(_id);
    }

    function getContact(uint256 _id) external view returns (Contact memory) {
        for (uint256 i = 0; i < contacts.length; i++) {
            if (contacts[i].id == _id) {
                return contacts[i];
            }
        }
        revert ContactNotFound(_id);
    }

    function getAllContacts() external view returns (Contact[] memory) {
        uint256 _notDeleted = 0;
        for (uint256 i = 0; i < contacts.length; i++) {
            if (contacts[i].phoneNumbers.length != 0) {
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