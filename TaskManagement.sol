// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract TaskManagement {
    struct Task {
        string title;
        string description;
        address assignee;
        bool isCompleted;
    }

    mapping(uint => Task) public tasks;
    uint public taskCount;

    event TaskCreated(uint indexed taskId, string title, string description, address assignee);
    event TaskCompleted(uint indexed taskId, address completer);

    function createTask(string memory _title, string memory _description, address _assignee) public {
        taskCount++;
        tasks[taskCount] = Task({
            title: _title,
            description: _description,
            assignee: _assignee,
            isCompleted: false
        });
        emit TaskCreated(taskCount, _title, _description, _assignee);
    }

    function completeTask(uint _taskId) public {
        require(tasks[_taskId].assignee == msg.sender, "Not the task assignee");
        tasks[_taskId].isCompleted = true;
        emit TaskCompleted(_taskId, msg.sender);
    }

    function getTask(uint _taskId) public view returns (string memory, string memory, address, bool) {
        Task memory task = tasks[_taskId];
        return (task.title, task.description, task.assignee, task.isCompleted);
    }
}