const Lottery = artifacts.require("Lottery.sol");
const TestERC721 = artifacts.require("./contracts/TestERC721.sol");
const { time } = require('openzeppelin-test-helpers');

contract("NFT Lottery", accounts => {
	let testERC721;
    let lottery;
    let lotteryId;
    let start_at
    let end_at;
    let erc721Token;
    let  assetId;

	beforeEach(async () => {
        testERC721 = await TestERC721.new();
        lottery = await Lottery.new();
        lotteryId = 1;
        assetId = 1;
        start_at = (await time.latest()).add(time.duration.weeks(1));
        end_at = (await time.latest()).add(time.duration.weeks(2));
        erc721Token = testERC721.address;
        await testERC721.mint(accounts[0], assetId,{from:accounts[0]});
    });
    it(" Start a lottery", async () => {

        const txp = await lottery.startLottery(
            lotteryId, 
            start_at,
            end_at, 
            erc721Token,
            assetId, 
            { from: accounts[1] }
        );
        const lettories = await lottery.lotteries(1);
        assert.equal(lettories.assetId, lotteryId);
    });
    it(" Participate in lottery", async () => {
        const txp = await lottery.startLottery(
            lotteryId, 
            start_at,
            end_at, 
            erc721Token, 
            assetId, 
            { from: accounts[1] }
        );
        const result = await lottery.participate(lotteryId, {from: accounts[2]});
        const participant = await lottery.participants(1,0);
        assert.equal(participant, accounts[2]);
    });

    it(" End lottery", async () => {
        await testERC721.setApprovalForAll(lottery.address, true, {from: accounts[0]});
        const txp = await lottery.startLottery(
            lotteryId, 
            start_at,
            end_at, 
            erc721Token, 
            assetId, 
            { from: accounts[0] }
        );
        await lottery.participate(lotteryId, {from: accounts[2]});
        await lottery.participate(lotteryId, {from: accounts[3]});
        await lottery.endLottery(lotteryId, {from: accounts[0]});
        const isOlderOwner = (await testERC721.ownerOf(assetId)) == accounts[0];
        assert.isFalse(isOlderOwner, "New NFT owner proceessed")    
    });

});
