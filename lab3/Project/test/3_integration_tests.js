const RockPaperScissorsContract = artifacts.require("RockPaperScissors");
const NewContract = artifacts.require("NewContract");

contract("Integration testing", function() {
    it("Cant start game without choices", async () => {
        Contract = await RockPaperScissorsContract.deployed();
        contract2 = await NewContract.deployed();
        contract2.define_contract_by_address(Contract.address);

        let started = true;
        try {
            await contract2.start_game()
        } catch (err) {
            started = false;
        }
        assert.equal(started, false)
    });
    it("Correctness of commitments", async () => {
        await contract2.commit_choice('0x6ddd7a461178d619ded2166136acb78861adc008261cc2f27ea3620daa97b79e');
        await contract2.commit_choice('0x23042851a6c1138950f531741e3b75f9bb756e19c290c98be214a5a3d09109bf');
        player1 = await Contract.players.call(0);
        player2 = await Contract.players.call(1);
        assert.equal(player1.commitment, '0x6ddd7a461178d619ded2166136acb78861adc008261cc2f27ea3620daa97b79e');
        assert.equal(player2.commitment, '0x23042851a6c1138950f531741e3b75f9bb756e19c290c98be214a5a3d09109bf');
        assert.equal(player1.choice,'');
        assert.equal(player2.choice,'');
        assert.notEqual(player1.player_address, '0x0000000000000000000000000000000000000000')
        assert.notEqual(player2.player_address, '0x0000000000000000000000000000000000000000')
        assert.equal(player1.player_address, player2.player_address);
    });
    it("Correctness of raise exception in incorrect hash (in reveal)", async () => {
        let revealed = true;
        try {
            await contract2.reveal_choice('1', '1');
        } catch (err) {
            revealed = false;
        }
        assert.equal(revealed, false)
    });
    it("Correctness of removing game", async () => {
        await contract2.restart_game();
        player1 = await Contract.players.call(0);
        player2 = await Contract.players.call(1);
        assert.equal(player1.player_address, '0x0000000000000000000000000000000000000000');
        assert.equal(player2.player_address, '0x0000000000000000000000000000000000000000');
        assert.equal(player1.commitment, '0x0000000000000000000000000000000000000000000000000000000000000000');
        assert.equal(player2.commitment, '0x0000000000000000000000000000000000000000000000000000000000000000');
        assert.equal(player1.choice, '');
        assert.equal(player2.choice, '');
    });
    
})
