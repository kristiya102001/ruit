// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract VotingSystem {
    struct Proposal {
        string description;
        uint yesVotes;
        uint noVotes;
        bool isActive;
    }

    mapping(uint => Proposal) public proposals;
    uint public proposalCount;

    event ProposalCreated(uint indexed proposalId, string description);
    event Voted(uint indexed proposalId, bool isYes, address voter);

    function createProposal(string memory _description) public {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            description: _description,
            yesVotes: 0,
            noVotes: 0,
            isActive: true
        });
        emit ProposalCreated(proposalCount, _description);
    }

    function vote(uint _proposalId, bool _isYes) public {
        require(proposals[_proposalId].isActive, "Proposal is not active");
        if (_isYes) {
            proposals[_proposalId].yesVotes++;
        } else {
            proposals[_proposalId].noVotes++;
        }
        emit Voted(_proposalId, _isYes, msg.sender);
    }

    function endProposal(uint _proposalId) public {
        require(proposals[_proposalId].isActive, "Proposal is not active");
        proposals[_proposalId].isActive = false;
    }

    function getProposal(uint _proposalId) public view returns (string memory, uint, uint, bool) {
        Proposal memory proposal = proposals[_proposalId];
        return (proposal.description, proposal.yesVotes, proposal.noVotes, proposal.isActive);
    }
}