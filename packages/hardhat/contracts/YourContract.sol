// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract YourContract {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;
    uint256 public votingStartTime;
    uint256 public votingEndTime;

    event VotedEvent(uint indexed candidateId);

    constructor() {
        addCandidate("Alice");
        addCandidate("Bob");
        votingStartTime = block.timestamp;
        votingEndTime = votingStartTime + 1 days; // Periodo de votación de 1 día
    }

    function addCandidate(string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public {
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate.");
        require(block.timestamp <= votingEndTime, "Voting period has ended.");

        // Simulación de verificación de ZKP
        require(verifyZKP(msg.sender), "ZKP verification failed.");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit VotedEvent(_candidateId);
    }

    function verifyZKP(address _voter) private pure returns (bool) {
        // Aquí se simula la verificación de ZKP
        // En un caso real, se implementaría la lógica de verificación adecuada
        return _voter != address(0); // Ejemplo simple: siempre devuelve true
    }

    function getCandidate(uint _candidateId) public view returns (uint, string memory, uint) {
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name, candidate.voteCount);
    }

    function hasVotingEnded() public view returns (bool) {
        return block.timestamp > votingEndTime;
    }
}