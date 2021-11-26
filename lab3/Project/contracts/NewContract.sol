pragma solidity <0.9;
// SPDX-License-Identifier: MIT

import "./RockPaperScissors.sol";

contract NewContract {
    RockPaperScissors Contract;
    // Game MainContract;

    function define_contract_by_address(address addr) public {
        Contract = RockPaperScissors(addr);
    }
    
     function start_game() public {
        Contract.start_game();
    }
    
    function restart_game() public {
        Contract.restart_game();
    }

    // лучше не использовать, ставится адрес контракта, который вызывает методы
    // как минимум один из игроков должен напрямую дернуть метод из RockPaperScissors
    function commit_choice(bytes32 data) public {
        Contract.commit_choice(data);
    }

    // аналогично с предыдущим
    function reveal_choice(string memory choice, string memory password) public {
        Contract.reveal_choice(choice, password);
    }
} 