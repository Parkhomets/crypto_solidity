// SPDX-License-Identifier: MIT
// test challenge for lab work #2. Created by Pavel Parkhomets

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract RockPaperScissors_CommitReveal {
    
    struct PlayerChoice {
        string choice;
        address player_address;
        bytes32 commitment; //hidden_choice = keccak256(choice+password)
    }
    
    // event Revealed
    event Revealed(address player, string choice);
    
    // init two players
    PlayerChoice[2] public players;
    uint public vacant_choices = 2;
    address public game_winner;
    
    
    // set permitted choices in reveal stage
    function set_choice1(string memory data) internal only_permitted_choice(data) {
        players[0].choice = data;
    }
    function set_choice2(string memory data) internal only_permitted_choice(data) {
        players[1].choice = data;
    }
    
    // send hidden_choice
    function commit_choice(bytes32 hidden_choice) public is_choices_vacant() {
        if (vacant_choices == 2) { // step of 1st player
            players[0].commitment = hidden_choice;
            players[0].player_address = msg.sender;
        } else if (vacant_choices == 1) { // step of 2nd player
            players[1].commitment = hidden_choice;
            players[1].player_address = msg.sender;
        } 
        vacant_choices = vacant_choices - 1;
    }
    
    //reveal hidden_choice and show players choices
    function reveal_choice(string memory choice, string memory password) public reveal_stage() {
        //find player hidden_choice and his index
        uint index;
        if (bytes(players[0].choice).length == 0 && players[0].player_address == msg.sender) {
            index = 0;
        } else if (bytes(players[1].choice).length == 0 && players[1].player_address == msg.sender) {
            index = 1;
        } else {
            revert("Player not found or all secrets already revealed!");
        }
        
        require(keccak256(abi.encodePacked(choice, password)) == players[index].commitment, "invalid hash");
        
        if (index == 0){
            set_choice1(choice);
        } else if (index == 1) {
            set_choice2(choice);
        }
    }
    
    //define winner
    function get_winner() internal is_game_ready()  returns (address addr){
        // rock - len = 4 
        // paper - len = 5
        // scissors - len = 8
        
        string memory choice1 = players[0].choice;
        string memory choice2 = players[1].choice;
        
        address winner;
        if (bytes(choice1).length == bytes(choice2).length) { //nobody
            return winner;
        } else if (bytes(choice1).length == 4 && bytes(choice2).length == 5) { //rock (palyer1) and paper (player2)
            return players[1].player_address;
        } else if (bytes(choice1).length == 5 && bytes(choice2).length == 4) { //paper (palyer1) and rock (player2)
            return players[0].player_address;
        } else if (bytes(choice1).length == 4 && bytes(choice2).length == 8) { //rock (palyer1) and scissors (player2)
            return players[0].player_address;
        } else if (bytes(choice1).length == 8 && bytes(choice2).length == 4) { //scissors (palyer1) and rock (player2)
            return players[1].player_address;
        } else if (bytes(choice1).length == 5 && bytes(choice2).length == 8) { //paper (palyer1) and scissors (player2)
            return players[1].player_address;
        } else if (bytes(choice1).length == 8 && bytes(choice2).length == 5) { //scissors (palyer1) and paper (player2)
            return players[0].player_address;
        }
    }
    
    function start_game() public  returns (address winner) {
        // send events to players
        emit Revealed(players[0].player_address, players[0].choice);
        emit Revealed(players[1].player_address, players[1].choice);
        address winner1 = get_winner();
        game_winner = winner1;
        return winner1;
    }
    
    function restart_game() public returns (string memory){
        delete players;
        vacant_choices = 2;
        return "All values have been dropped!";
    }
    
    

    //check if some choices is empty
    modifier is_choices_vacant() {
        bool something_empty = false;
        if (vacant_choices > 0) {
            something_empty = true;
        }
        require(something_empty == true, "Players have already done their choices! Reveal it and start game!");
        _;
    }
    
    //check choices filling
    modifier is_game_ready() {
        bool ready = false;
        if (bytes(players[0].choice).length != 0 && bytes(players[1].choice).length != 0) {
            ready = true;
        }
        require(ready == true, "Players must make choice and reveal it!");
        _;
    }
    
	// check only permitted choises - scissors, rock, paper
    modifier only_permitted_choice(string memory user_choice) {
        string memory possible_choice1 = "scissors";
        string memory possible_choice2 = "rock";
        string memory possible_choice3 = "paper";
        
        bool permitted = false;
        if (keccak256(abi.encodePacked(user_choice)) == keccak256(abi.encodePacked(possible_choice1))) {
            permitted = true;
        } else if (keccak256(abi.encodePacked(user_choice)) == keccak256(abi.encodePacked(possible_choice2))) {
            permitted = true;
        } else if (keccak256(abi.encodePacked(user_choice)) == keccak256(abi.encodePacked(possible_choice3))) {
            permitted = true;
        }
        
        require(permitted == true, "Not in allowed words! Allowed words: rock, scissors, paper");
        _;
    }

    
    modifier reveal_stage() {
        bool reveal = false;
        if (vacant_choices == 0) {
            reveal = true;
        }
        require(reveal == true, "Players must make choice!");
        _;
    }
    
}
