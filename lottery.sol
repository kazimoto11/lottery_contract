pragma solidity >=0.4.17;

contract Lottery{
    address public manager;
    address payable[] public players;
   // Constructor function of lottery
   //Address of manager calling the function
    constructor() public payable{
        manager = msg.sender;
    }
    function enter() public payable{
        require(msg.value > 0.01 ether,"Insufficient amount");
        players.push(msg.sender);
        }

    // randomness we have 3 features
    // Current block difficulty
    // Current time
    // Addresses of players
    // Which are fed to the SHA3 Algorithm to give a really big number
    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp, players)));

    }
    function pickWinner() public restricted payable{
        // Check if the person calling the function is manager using the modifier restricted
        uint index = random() % players.length;
        // .transfer() transfers the money to address//
        // this.balance transfers all the ether inside the contract
        players[index].transfer(address (this).balance); // address
        players = new address payable[] (0); // Initializing the contract again without redeploying it
    }
    modifier restricted() {
         // Check if the person calling the function is manager
        require(msg.sender == manager,"Not authorized to call the function");
        _;
    }
    function getPlayers() public view returns(address payable[] memory){
        return players;
    }
}