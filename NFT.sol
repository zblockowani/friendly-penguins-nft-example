//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

error NFT_LimitReached();

contract NFT is ERC721 {
    uint256 private s_counter;
    uint256 private s_limit;
    string private s_cid;
    uint256[] private s_remainingTokens;

    event Minted(address _who, uint256 _id);

    constructor(string memory _name, string memory _symbol, uint256 _limit, string memory _cid)
        ERC721(_name, _symbol)
    {
        s_limit = _limit;
        s_cid = _cid;

        for(uint i = 0; i < _limit; i++) {
            s_remainingTokens.push(i);
        }
    }

    function mint() public {
        if(s_counter == s_limit) {
            revert NFT_LimitReached();
        }
        
        uint256 id = drawToken();
        _mint(msg.sender, id);
        
        s_counter++;
        emit Minted(msg.sender, id);
    }

     function _baseURI() internal view override returns (string memory) {
        return s_cid;
    }

    function drawToken() private returns(uint256) {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.number)));
        uint256 tokenIndex = randomNumber % s_remainingTokens.length;
        
        uint256 tokenId = s_remainingTokens[tokenIndex];
        
        s_remainingTokens[tokenIndex] = s_remainingTokens[s_remainingTokens.length - 1];
        s_remainingTokens.pop();

        return tokenId;
    }
}