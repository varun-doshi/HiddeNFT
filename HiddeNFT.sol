pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HiddeNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => uint256) private codeMap;
    mapping(uint256 => bool) private visibleMap;

    constructor() ERC721("HiddeNFT", "HDN") {}

    function mintNFT(address to,string memory uri) public onlyOwner{
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(to, newTokenId);
        _setTokenURI(newTokenId, uri);
        uint256 r=random();
        codeMap[newTokenId] = r;
        visibleMap[newTokenId]=false;
    }

     function random() internal view returns(uint256){
        return (uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp))))%6;
    }

    function reveal(uint256 tokenId) public {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId)==msg.sender,"Only the owner can perform this operation");
        require(!visibleMap[tokenId], "Code is already revealed");
        visibleMap[tokenId] = true;
    }

     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId)==msg.sender,"Only the owner can perform this operation");
        require(visibleMap[tokenId], "Code has not been revealed");
        super._burn(tokenId);
    }







     // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }


    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}