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
}