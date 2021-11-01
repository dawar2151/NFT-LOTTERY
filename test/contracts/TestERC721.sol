// SPDX-License-Identifier: MIT

pragma solidity >=0.6.9 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract TestERC721 is ERC721("lot", "LTT") {
    function mint(address to, uint assetId) external {
        _mint(to, assetId);
    }
}
