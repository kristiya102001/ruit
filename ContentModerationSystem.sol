// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract ContentModerationSystem {
    struct Content {
        string hash;
        string metadata;
        bool approved;
        address submitter;
        uint timestamp;
    }

    mapping(bytes32 => Content) public contents;
    mapping(bytes32 => bool) public contentExists;

    event ContentSubmitted(bytes32 indexed contentId, string hash, string metadata, address submitter);
    event ContentApproved(bytes32 indexed contentId);

    function submitContent(string memory _hash, string memory _metadata) public {
        bytes32 contentId = keccak256(abi.encodePacked(_hash, _metadata, msg.sender));
        require(!contentExists[contentId], "Content already submitted");
        contents[contentId] = Content({
            hash: _hash,
            metadata: _metadata,
            approved: false,
            submitter: msg.sender,
            timestamp: block.timestamp
        });
        contentExists[contentId] = true;
        emit ContentSubmitted(contentId, _hash, _metadata, msg.sender);
    }

    function approveContent(bytes32 _contentId) public {
        require(contentExists[_contentId], "Content does not exist");
        require(!contents[_contentId].approved, "Content already approved");
        contents[_contentId].approved = true;
        emit ContentApproved(_contentId);
    }

    function getContent(bytes32 _contentId) public view returns (string memory, string memory, bool, address, uint) {
        require(contentExists[_contentId], "Content does not exist");
        Content memory content = contents[_contentId];
        return (content.hash, content.metadata, content.approved, content.submitter, content.timestamp);
    }
}