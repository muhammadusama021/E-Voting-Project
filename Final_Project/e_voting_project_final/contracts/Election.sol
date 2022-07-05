


// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
contract Election {
    //Structure that represents a registered voter in the election
    struct Voter {
        string name;
        string regNo;
        bool isRegistered;
        bool hasVoted; //Whether or not the voter has voted yet
        uint256 weight; // Weight of the Voter
        uint256 voteTowards; //States the candidate's ID to which the voter has voted//States the candidate's ID to which the voter has voted
    }
    //Structure that represents a registered candidate in the election
    struct Candidate {
        uint256 ID; // The unique ID of the candidate
        string name;
        string regNo;// Name of the candidate

    }


    mapping(uint => address) private voterID; // VoterID mapped to voter address
    mapping(address => Voter) private voters; //address of voter mapped to the voter struct - To view all registered voters
    mapping(uint256 => Candidate) private candidates; // ID of candidate mapped to the candidate struct - To view details of all registered candidates
    mapping(uint256 => uint256) private voteCount;// ID of the candidate mapped to the votes of the candidate privately


    address public admin; // The address of the official/authority conducting the election

    enum State {CREATED, ONGOING, CONCLUDED}
    /*This enum represents the state of the election -
    CREATED - The election contract has been created, voting has not begun yet
    ONGOING - The voting has begun and is currently active
    STOP - The voting period has ended and it is time for counting
    */

    State  electionState; // A variable of the type enum State to represent the election state
    string public description;
    string public electionName;
    uint256 public candidate_count;    // Keeps a count of the registered candidates
    uint256 public voter_count;
    //modifier to check if the address is of the admin's as several functions can only be accessed by the admin
    modifier checkAdmin(address owner) {
        require(
            owner == admin, "Only the election admin has access to this function."
        );
        _;
    }

    //modifiers to check for the states of the election
    modifier checkIfCreated() {
        require(
            electionState == State.CREATED, "The election is either ongoing or has concluded."
        );
        _;
    }

    modifier checkIfOngoing() {
        require(
            electionState == State.ONGOING, "Election is not active or ongoing currently."
        );
        _;
    }

    modifier checkIfComplete() {
        require(electionState == State.CONCLUDED, "The election has not concluded yet.");
        _;
    }

    modifier checkNotComplete() {
        require(electionState != State.CONCLUDED, "The election has concluded.");
        _;
    }

    //modifier to check if a voter is a valid voter
    modifier checkIfVoterValid(address owner) {
        require(
            !voters[owner].hasVoted,
            "Voter has already voted."
        );
        require(
            voters[owner].weight > 0,
            "Voter has not been registered or already delegated their vote."
        );
        _;
    }

    //modifier to check if the candidate being voted for is a valid candidate
    modifier checkIfCandidateValid(uint256 _candidateId) {
        require(
            _candidateId > 0 && _candidateId <= candidate_count,
            "Invalid candidate."
        );
        _;
    }

    //modifier to check if the person is not an admin
    modifier checkNotAdmin(address owner) {
        require(
            owner != admin,
            "The election admin is not allowed to access this function."
        );
        _;
    }

    //modifier to check if the voter is not yet registered for the addVoter function
    modifier checkNotRegistered(address voter) {
        require(
            !voters[voter].hasVoted && !voters[voter].isRegistered,
            "Voter has already been registered."
        );
        _;
    }

    //events to be logged into the blockchain
    event AddedAVoter(address voter);
    event VotedSuccessfully(uint256 candidateId);
    event ElectionStart(string name,State election_state);
    event ElectionEnd(State election_state);
    event AddedACandidate(uint candidateID, string candidateName, string candidateRegNo);


    // Initialization
    constructor(address owner, string memory desc) public{
        admin = owner;
        electionState = State.CREATED; // Setting Eection state to CREATED
        description = desc;

    }

    function checkState() public view returns (string memory state)
    {
        if(electionState == State.CREATED)
            return "CREATED";
        else if(electionState == State.ONGOING)
            return "ONGOING";
        else if(electionState == State.CONCLUDED)
            return "CONCLUDED";
    }
    // To Add a candidate
    // Only admin can add and
    // candidate can be added only before election starts
    function addCandidate(string memory _name, string memory _regNo, address owner)
    public
    checkAdmin(owner)

    {
        candidate_count++;
        candidates[candidate_count].ID = candidate_count;
        candidates[candidate_count].name = _name;
        candidates[candidate_count].regNo = _regNo;
        voteCount[candidate_count] = 0;
        emit AddedACandidate(candidate_count, _name, _regNo);
    }

    // To add a voter
    // only admin can add
    // can add only before election starts
    // can add a voter only one time
    function addVoter(address _voter,string memory name,string memory regNo, address owner)
    public
    checkAdmin(owner)
    checkNotRegistered(_voter)

    {
        voter_count++;
        voterID[voter_count] = _voter;
        voters[_voter].name = name;
        voters[_voter].regNo = regNo;
        voters[_voter].weight = 1;
        voters[_voter].isRegistered = true;
        emit AddedAVoter(_voter);
    }
    // setting Election state to ONGOING
    // by admin
    function startElection(string memory name,address owner) public checkAdmin(owner) {
        electionName=name;

        electionState = State.ONGOING;

        emit ElectionStart(electionName,electionState);
    }
    function getElectiondetails() public view returns (string memory name,string memory state)
    {
        return(
        electionName,
        checkState()
        );
    }




    // To display candidates
    function displayCandidate(uint256 _ID)
    public
    view
    returns (
        uint256 id,
        string memory name,
        string memory regNo
    )
    {
        return (
        candidates[_ID].ID,
        candidates[_ID].name,
        candidates[_ID].regNo
        );
    }

    //Show winner of election
    function showWinner()
    public
    view
    checkIfComplete
    returns (string memory name, uint256 id, uint256 votes)
    {
        uint256 max;
        uint256 maxIndex;
        string memory winner;
        for (uint256 i = 1; i <= candidate_count; i++) {
            if (voteCount[i] > max) {
                winner = candidates[i].name;
                maxIndex = i;
                max = voteCount[i];
            }
        }
        return (winner,maxIndex, max) ;
    }




    // to cast the vote
    function vote(uint256 _ID, address owner)
    public
    checkIfOngoing
    checkIfVoterValid(owner)
    {
        voters[owner].hasVoted = true;
        voters[owner].voteTowards = _ID;
        voteCount[_ID] += voters[owner].weight;
        voters[owner].weight = 0;
        emit VotedSuccessfully(_ID);
    }

    // Setting Election state to STOP
    // by admin
    function endElection(address owner) public checkAdmin(owner) {
        electionState = State.CONCLUDED;
        emit ElectionEnd(electionState);
    }

    // to display result
    function showResults(uint256 _ID)
    public
    view
    returns (
        uint256 id,
        string memory name,
        string memory regNo,
        uint256 count
    )
    {
        return (_ID, candidates[_ID].name, candidates[_ID].regNo,voteCount[_ID]);
    }

    function getVoter(uint256 ID, address owner)  public view checkAdmin(owner)
    returns (
        uint256 id,
        address voterAddress,
        uint256 weight
    )
    {
        return (
        ID,
        voterID[ID],
        voters[voterID[ID]].weight
        );
    }

    function voterProfile(address voterAddress) public view
    returns (
        uint256 id,
        string memory voterName,
        string memory voterReg,
        uint256 weight,
        uint256 votedTowards,
        string memory name
    )
    {

        for(uint256 i = 1; i<= voter_count; i++)
        {
            if(voterAddress == voterID[i])
            {
                return (
                i,
                voters[voterID[i]].name,
                voters[voterID[i]].regNo,
                voters[voterID[i]].weight,
                voters[voterID[i]].voteTowards,
                candidates[voters[voterID[i]].voteTowards].name
                );
            }
        }
    }
}