// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract CommunityProposalSystem {
    struct Proposal {
        string title;
        string description;
        uint voteCount;
        bool executed;
    }

    mapping(uint => Proposal) public proposals;
    uint public proposalCount;
    mapping(address => mapping(uint => bool)) public hasVoted;

    event ProposalCreated(uint indexed proposalId, string title, string description);
    event VoteCast(uint indexed proposalId, address voter);
    event ProposalExecuted(uint indexed proposalId);

    function createProposal(string memory _title, string memory _description) public {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            title: _title,
            description: _description,
            voteCount: 0,
            executed: false
        });
        emit ProposalCreated(proposalCount, _title, _description);
    }

    function castVote(uint _proposalId) public {
        require(_proposalId <= proposalCount, "Proposal does not exist");
        require(!hasVoted[msg.sender][_proposalId], "Already voted");
        proposals[_proposalId].voteCount++;
        hasVoted[msg.sender][_proposalId] = true;
        emit VoteCast(_proposalId, msg.sender);
    }

    function executeProposal(uint _proposalId) public {
        require(_proposalId <= proposalCount, "Proposal does not exist");
        require(!proposals[_proposalId].executed, "Proposal already executed");
        proposals[_proposalId].executed = true;
        emit ProposalExecuted(_proposalId);
    }

    function getProposal(uint _proposalId) public view returns (string memory, string memory, uint, bool) {
        require(_proposalId <= proposalCount, "Proposal does not exist");
        Proposal memory proposal = proposals[_proposalId];
        return (proposal.title, proposal.description, proposal.voteCount, proposal.executed);
    }
}