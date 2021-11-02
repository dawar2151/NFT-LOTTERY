pragma solidity >=0.6.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import './ILottery.sol';

contract Lottery is ILottery, Ownable{
    
    // list of participants by lottery
    mapping( uint=> address[]) public participants;
    
    // NFT lotteries started by an owner
    mapping(uint=>LOT) public lotteries;

    mapping(uint=>bool) public checkLottery;

    constructor(){

    }
    /**
    * @dev start a new lottery
    * @param start_at the lottery start time
    * @param end_at the lottery start time
    * @param erc721Token the lottery  nft collection address
    * @param assetId the nft token
     */
    function startLottery(uint lotteryId, uint  start_at, uint  end_at, address erc721Token, uint assetId) override external returns(bool){
        require(start_at > block.timestamp, "NFT Lottery: invalid start_at");
        require(start_at < end_at, "NFT Lottery: invalid end_at");
        if(!checkLottery[lotteryId]){
            lotteries[lotteryId] = LOT(
                _msgSender(),
                start_at,
                end_at,
                IERC721(erc721Token),
                assetId
            );
            checkLottery[lotteryId] = true;
        }
        return true;    
    }
    /**
    * @dev pick a winner
    * @param lotteryId a lottery id
     */
    function random(uint lotteryId) private view returns(uint){
         return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp,  participants[lotteryId])));
    }
    /**
    * @dev particpate in a lottery
    * @param lotteryId a lottery id
    *
     */
    function participate(uint lotteryId) override external returns(bool){
        participants[lotteryId].push(_msgSender());
        return true;
    }
    /**
    * @dev pick a random winner and send him and ERC721 token
    * @param lotteryId a lottery id
     */
    function endLottery(uint lotteryId) onlyOwner() override external returns(bool) {
        require(_msgSender() == lotteries[lotteryId].creator, "Lottery: user must be owner");
        uint index = random(lotteryId) % participants[lotteryId].length;
        lotteries[lotteryId].ERC_721_TOKEN.transferFrom(_msgSender(), participants[lotteryId][index], lotteries[lotteryId].assetId);
        participants[lotteryId] = new address[](0);
        return true;
     }

}
