const RockPaperScissorsContract = artifacts.require("RockPaperScissors");

contract("Unit testing", function() {
    it("--> Check init values <--", async () => {
        Contract = await RockPaperScissorsContract.deployed();
        let player_1 = await Contract.players.call(0);
        let player_2 = await Contract.players.call(1);
        let vacant_choices = await Contract.vacant_choices.call();

        assert.equal(player_1.player_address, '0x0000000000000000000000000000000000000000');
        assert.equal(player_2.player_address, '0x0000000000000000000000000000000000000000');
        assert.equal(player_1.commitment, '0x0000000000000000000000000000000000000000000000000000000000000000');
        assert.equal(player_2.commitment, '0x0000000000000000000000000000000000000000000000000000000000000000');
        assert.equal(player_1.choice, '');
        assert.equal(player_2.choice, '');
        assert.equal(vacant_choices, 2);
    });

    it("--> Check commitment saving <--", async () => {
        await Contract.commit_choice('0x6ddd7a461178d619ded2166136acb78861adc008261cc2f27ea3620daa97b79e');

        player_1 = await Contract.players.call(0);
        player_2 = await Contract.players.call(1);

        assert.notEqual(player_1.player_address, '0x0000000000000000000000000000000000000000');
        assert.equal(player_2.player_address, '0x0000000000000000000000000000000000000000');
        assert.equal(player_1.commitment, '0x6ddd7a461178d619ded2166136acb78861adc008261cc2f27ea3620daa97b79e');
        assert.equal(player_2.commitment, '0x0000000000000000000000000000000000000000000000000000000000000000');
        assert.equal(player_1.choice, '');
        assert.equal(player_2.choice, '');
        // assert.equal(vacant_choices, 2);
    });
    it("--> Check vacant choices decrease <--", async () => {
        vacant_choices = await Contract.vacant_choices.call();
        assert.equal(vacant_choices, 1);
    });
    it("--> Check not starting not ready game (raise exception) <--", async () => {
        let started = true;
        try {
            await Contract.start_game()
        } catch (err) {
            started = false;
        }
        assert.equal(started, false)
    });
    it("--> Check cant reveal not commited choice (raise exception) <--", async () => {
        let revealed = true;
        try {
            await Contract.reveal_choice('paper', 'secret');
        } catch (err) {
            revealed = false;
        }
        assert.equal(revealed, false)
    });
    it("--> Check reveal with incorrect secret (raise exception) <--", async () => {
        await Contract.commit_choice('0x23042851a6c1138950f531741e3b75f9bb756e19c290c98be214a5a3d09109bf');
        let revealed = true;
        try {
            await Contract.reveal_choice('paper', 'secret1234');
        } catch (err) {
            revealed = false;
        }
        assert.equal(revealed, false)
    });
    it("--> Check corectness of reveal <--", async () => {
        // await Contract.commit_choice('0x23042851a6c1138950f531741e3b75f9bb756e19c290c98be214a5a3d09109bf');
        await Contract.reveal_choice('paper', 'secret');
        await Contract.reveal_choice('rock', 'secret');
        player_1 = await Contract.players.call(0);
        player_2 = await Contract.players.call(1);
        assert.equal(player_1.choice, 'paper');
        assert.equal(player_2.choice, 'rock');
    });
})