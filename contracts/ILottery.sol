pragma solidity >=0.6.0 <0.9.0;
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

interface ILottery{
    struct LOT {
        uint start_at;
        uint end_at;
        IERC721 ERC_721_TOKEN;
        uint assetId;
    }
    function participate(uint lotteryId )  external returns(bool);
    function startLottery(uint lotteryId, uint  start_at, uint  end_at, address erc721Token, uint assetId) external returns(bool);
    function endLottery(uint lotteryId) external  returns(bool);
}
