// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    error HaikuNotUnique();
    error NotYourHaiku(uint256 _id);
    error NoHaikusShared();

    Haiku[] public haikus;
    mapping(address => uint256[]) public sharedHaikus;
    mapping(string => bool) lineUsed;
    uint256 public counter;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        counter = 1;
    }

    function mintHaiku(string calldata _line1, string calldata _line2, string calldata _line3) external {
        if (lineUsed[_line1] || lineUsed[_line2] || lineUsed[_line3]) {
            revert HaikuNotUnique();
        }
        _safeMint(msg.sender, counter);
        haikus.push(Haiku(msg.sender, _line1, _line2, _line3));
        lineUsed[_line1] = true;
        lineUsed[_line2] = true;
        lineUsed[_line3] = true;
        counter++;
    }

    function shareHaiku(uint256 _id, address _to) public {
        if (msg.sender != _ownerOf(_id)) {
            revert NotYourHaiku(_id);
        }
        sharedHaikus[_to].push(_id);
    }

    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256[] memory sharedIds = sharedHaikus[msg.sender];
        if (sharedIds.length == 0) {
            revert NoHaikusShared();
        }
        Haiku[] memory _sharedWithUser = new Haiku[](sharedIds.length);
        for (uint256 i = 0; i < sharedIds.length; i++) {
            _sharedWithUser[i] = haikus[sharedIds[i] - 1];
        }
        return _sharedWithUser;
    }
}