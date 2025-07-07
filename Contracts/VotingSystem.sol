// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Decentralized Voting System
/// @author Hitesh Pal
/// @notice Simple demo contract for Core EC assignment
contract VotingSystem {
    /* ---------- DATA ---------- */
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    address public immutable admin;
    mapping(address => bool) public hasVoted;
    mapping(uint256 => Candidate) private candidates;
    uint256 public candidatesCount;

    /* ---------- EVENTS ---------- */
    event CandidateAdded(uint256 indexed id, string name);
    event Voted(address indexed voter, uint256 indexed candidateId);

    /* ---------- MODIFIERS ---------- */
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /* ---------- ADMIN ACTIONS ---------- */
    function addCandidate(string calldata _name) external onlyAdmin {
        require(bytes(_name).length > 0, "Name required");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit CandidateAdded(candidatesCount, _name);
    }

    /* ---------- PUBLIC ACTIONS ---------- */
    function vote(uint256 _candidateId) external {
        require(!hasVoted[msg.sender], "Already voted");
        require(
            _candidateId != 0 && _candidateId <= candidatesCount,
            "Invalid candidate"
        );

        // ✅ effects (state change) happen before any external interaction
        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit Voted(msg.sender, _candidateId);
    }

    /* ---------- VIEW HELPERS ---------- */
    function getCandidate(
        uint256 _candidateId
    ) external view returns (string memory name, uint256 votes) {
        require(
            _candidateId != 0 && _candidateId <= candidatesCount,
            "Invalid candidate"
        );
        Candidate storage c = candidates[_candidateId];
        return (c.name, c.voteCount);
    }
}
