// @tittle Voting System 
// @author Dogukan Kokce - <your names>

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

}