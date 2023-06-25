// @tittle Voting System 
// @author Dogukan Kokce - Mustafa Onur Başer - <your names>

/* ---------------------------------
  candidate   |   AGE   |      ID
 -----------------------------------
  Catherine   |    23    |    123X
  Gabriela    |    24    |    543T
  Joan        |    21    |    987P
  Javier      |    29    |    567W */

contract voting_system {
    //Address of the owner of the contract
    address owner;

    //We store the time value in which the elections begin
    uint start_voting;

    constructor() public {
        owner = msg.sender;
        start_voting = now;
    }

    // Relationship between the name of the candidate and the hash of their personal data
    mapping (string => bytes32) candidate_ID;

    // Relation between the name of the candidate and the number of votes
    mapping (string => uint) candidate_votes;

    //List to store the names of the candidates
    string [] candidates;

    //List of voter identity hashes
    bytes32 [] voters;


    /**
     * @dev This function is to register as a candidate for the elections
     * It is public for anyone to register
     * For this function to make sense we must::
     * 1. Create the hash of the candidate data.
     * 2. We store the hash of the candidate's data linked to their name.
     * 3. We store the name of the candidate in the dynamic array candidates.
     */

    function candidateRegistration(string memory _candidateName, uint _candidateAge, string memory _candidateId) public {
        //the current time plus 5 minutes
        require(now<=(start_voting + 5 minutes), "Candidates can no longer be submitted");
        bytes32 candidate_hash = keccak256(abi.encodePacked(_candidateName, _candidateAge, _candidateId));
        candidate_ID[_candidateName] = candidate_hash;
        candidates.push(_candidateName);     
    }

/**
     * @dev This function is to see all the candidates registered
     * For this function to make sense we must:
     * 1. We must to return the dynamic array where the candidates are storaged. 
     * string [] candidates;
     */

    function seeCandidates() public view returns(string[] memory) {
        return candidates;
    }

     /**
     * @dev This function is so that people can vote for a candidate
     * For this function to make sense we must:
     * 1. Calculate the hash of the address of the person who executes this function.
     * 2. We check if the voter has already voted.
     * 3. We store the hash of the voter inside the voters array in case they didn't vote. ´´string [] voters´´
     * 4. We verify that the candidate is on the list of candidates
     * 5. 4. Finally we add a vote to the selected candidate.
     */

    function Vote(string memory _candidate) public {
        //You can only vote within the voting period
        require(now<=start_voting + 5 minutes, "can no longer vote");
        
        bytes32 voter_hash = keccak256(abi.encodePacked(msg.sender));

        for(uint i = 0; i < voters.length; i++){
            require(voters[i] != voter_hash, "You already voted!");
        }

        voters.push(voter_hash);
        
        //The flag variable will be true if the candidate is on the list
        bool flag = false;
        
        for(uint j = 0; j < candidates.length; j++){
            // We compare the name of the candidate with the name of the candidate in position i
            if(keccak256(abi.encodePacked(candidates[j])) == keccak256(abi.encodePacked(_candidate))){
               //If they match we change the value of flag
                flag=true;
            }
        }
        // It is necessary that the candidate is on the list to be able to vote
        require(flag==true, "No hay ningun candidato con ese nombre");
        
        //Add a vote to the selected candidate
        candidate_votes[_candidate]++;
    }

}
