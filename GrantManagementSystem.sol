// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract GrantManagementSystem {
    struct Grant {
        string name;
        string description;
        uint amount;
        address recipient;
        bool approved;
    }

    mapping(uint => Grant) public grants;
    uint public grantCount;

    event GrantApplied(uint indexed grantId, string name, string description, uint amount, address recipient);
    event GrantApproved(uint indexed grantId);

    function applyForGrant(string memory _name, string memory _description, uint _amount) public {
        grantCount++;
        grants[grantCount] = Grant({
            name: _name,
            description: _description,
            amount: _amount,
            recipient: msg.sender,
            approved: false
        });
        emit GrantApplied(grantCount, _name, _description, _amount, msg.sender);
    }

    function approveGrant(uint _grantId) public {
        require(_grantId <= grantCount, "Grant does not exist");
        require(!grants[_grantId].approved, "Grant already approved");
        grants[_grantId].approved = true;
        emit GrantApproved(_grantId);
    }

    function getGrant(uint _grantId) public view returns (string memory, string memory, uint, address, bool) {
        require(_grantId <= grantCount, "Grant does not exist");
        Grant memory grant = grants[_grantId];
        return (grant.name, grant.description, grant.amount, grant.recipient, grant.approved);
    }
}