// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract ProjectManagement {
    struct Project {
        string name;
        string description;
        address manager;
        bool isActive;
    }

    mapping(uint => Project) public projects;
    uint public projectCount;

    event ProjectCreated(uint indexed projectId, string name, string description, address manager);
    event ProjectStatusChanged(uint indexed projectId, bool isActive);

    function createProject(string memory _name, string memory _description) public {
        projectCount++;
        projects[projectCount] = Project({
            name: _name,
            description: _description,
            manager: msg.sender,
            isActive: true
        });
        emit ProjectCreated(projectCount, _name, _description, msg.sender);
    }

    function changeProjectStatus(uint _projectId, bool _isActive) public {
        require(projects[_projectId].manager == msg.sender, "Not the project manager");
        projects[_projectId].isActive = _isActive;
        emit ProjectStatusChanged(_projectId, _isActive);
    }

    function getProject(uint _projectId) public view returns (string memory, string memory, address, bool) {
        Project memory project = projects[_projectId];
        return (project.name, project.description, project.manager, project.isActive);
    }
}