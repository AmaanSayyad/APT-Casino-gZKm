// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CasinoDAO {
    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    function createProposal(string memory description) external {
        proposals[proposalCount] = Proposal(proposalCount, description, 0, 0, false);
        proposalCount++;
    }

    function vote(uint256 proposalId, bool support) external {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");
        if (support) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }
    }

    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.votesFor > proposal.votesAgainst, "Proposal not approved");
        proposal.executed = true;
    }
}
