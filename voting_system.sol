// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract ElectionSystem {
    address private contractOwner;
    uint private electionStartTime;

    mapping (string => bytes32) private candidateHashes;
    mapping (string => uint) private candidateVotes;

    string [] private candidateNames;
    bytes32 [] private voterHashes;

    constructor() public {
        contractOwner = msg.sender;
        electionStartTime = now;
    }

    // Register a candidate for the election
    function registerCandidate(string memory candidateName, uint candidateAge, string memory candidateId) public {
        require(now <= (electionStartTime + 5 minutes), "Candidate registration period has ended");
        bytes32 candidateHash = keccak256(abi.encodePacked(candidateName, candidateAge, candidateId));
        candidateHashes[candidateName] = candidateHash;
        candidateNames.push(candidateName);
    }

    // View all registered candidates
    function viewRegisteredCandidates() public view returns(string[] memory) {
        return candidateNames;
    }

    // Vote for a candidate
    function castVote(string memory chosenCandidate) public {
        require(now <= (electionStartTime + 5 minutes), "Voting period has ended");
        
        bytes32 currentVoterHash = keccak256(abi.encodePacked(msg.sender));

        for(uint i = 0; i < voterHashes.length; i++){
            require(voterHashes[i] != currentVoterHash, "You have already cast your vote!");
        }

        voterHashes.push(currentVoterHash);
        
        bool isCandidateRegistered = false;
        
        for(uint j = 0; j < candidateNames.length; j++){
            if(keccak256(abi.encodePacked(candidateNames[j])) == keccak256(abi.encodePacked(chosenCandidate))){
                isCandidateRegistered = true;
            }
        }
        require(isCandidateRegistered, "Candidate with this name doesn't exist");
        
        candidateVotes[chosenCandidate]++;
    }

    // View votes of a candidate
    function viewVotesForCandidate(string memory candidate) public view returns(uint) {
        return candidateVotes[candidate];
    }

    // View election results
    function viewElectionResults() public view returns(string memory){
        string memory results = "";
        for(uint i = 0; i < candidateNames.length; i++){
            results = string(abi.encodePacked(results, "(", candidateNames[i], ", ", uintToString(viewVotesForCandidate(candidateNames[i])), ")---"));
        }
        return results;
    }

    // Declare the winner
    function declareWinner() public view returns(string memory){
        require(now > (electionStartTime + 5 minutes), "Voting period is not over yet.");
        
        string memory winner = candidateNames[0];
        bool isTie;
        
        for(uint i = 1; i <candidateNames.length; i++){
            if(candidateVotes[winner] < candidateVotes[candidateNames[i]]){
                winner = candidateNames[i];
                isTie = false;
            }else if(candidateVotes[winner] == candidateVotes[candidateNames[i]]){
                isTie = true;
            }
        }
        
        if(isTie){
            winner = "There is a tie between the candidates!";
        }
        return winner;
    }

    // Helper function to convert uint to string
    function uintToString(uint value) internal pure returns (string memory result) {
        if (value == 0) {
            return "0";
        }
        uint temp = value;
        uint digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = byte(uint8(48 + value % 10));
            value /= 10;
        }
        return string(buffer);
    }
}
