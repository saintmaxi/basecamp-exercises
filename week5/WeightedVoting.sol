// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./imports/ERC20.sol";
import "./imports/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;
    uint256 public maxSupply = 1_000_000;
    mapping(address => bool) hasClaimed;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 _amount);
    error AlreadyVoted();
    error VotingClosed();

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    struct IssueReturnType {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    Issue[] issues;

    enum Vote { AGAINST, FOR, ABSTAIN }

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}

    function claim() public {
        if (totalSupply() == maxSupply) {
            revert AllTokensClaimed();
        }
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        _mint(msg.sender, 100);
        hasClaimed[msg.sender] = true;
    }

    function createIssue(string calldata _description, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }
        issues.push();
        issues[issues.length - 1].issueDesc = _description;
        issues[issues.length - 1].quorum = _quorum;
        return issues.length - 1;
    }

    function getIssue(uint256 _id) external view returns (IssueReturnType memory) {
        require(_id <= issues.length - 1, "Invalid index!");
        return IssueReturnType(
            issues[_id].voters.values(),
            issues[_id].issueDesc,
            issues[_id].votesFor,
            issues[_id].votesAgainst,
            issues[_id].votesAbstain,
            issues[_id].totalVotes,
            issues[_id].quorum,
            issues[_id].passed,
            issues[_id].closed
        );
    }

    function vote(uint256 _issueId, Vote _vote) public {
        require(_issueId <= issues.length - 1, "Invalid index!");
        if (issues[_issueId].closed) {
            revert VotingClosed(); 
        }
        if (issues[_issueId].voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }
        if (_vote == Vote.AGAINST) {
            issues[_issueId].votesAgainst += balanceOf(msg.sender);
        }
        if (_vote == Vote.FOR) {
            issues[_issueId].votesFor += balanceOf(msg.sender);

        }
        if (_vote == Vote.ABSTAIN) {
            issues[_issueId].votesAbstain += balanceOf(msg.sender);
        }
        issues[_issueId].voters.add(msg.sender);

        if (issues[_issueId].votesFor >= issues[_issueId].quorum) {
            issues[_issueId].closed = true;
            if (issues[_issueId].votesFor > issues[_issueId].votesAgainst) {
                issues[_issueId].passed = true;
            }
        }            
    }
}