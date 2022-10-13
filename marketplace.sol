//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";

//The structure to store info about a listed token
struct ListedToken {
    address payable seller;
    uint256 price;
    bool isListed;
}

contract NFTMarketplace is ERC1155, Ownable, ERC1155Holder {
    using Counters for Counters.Counter;
    Counters.Counter internal _tokenIds;
    
    string public name;
    string public symbol;

    //the event emitted when a token is successfully listed
    event TokenListedSuccess (
        uint256 indexed tokenId,
        address owner,
        address seller,
        uint256 price,
        bool isListed
    );

    // tokenId => ListedToken
    mapping(uint256 => ListedToken) internal listedTokens;
    // tokenId => uri
    mapping(uint => string) public tokenURI;

    constructor() ERC1155("") {
        name = "ShopIt";
        symbol = "IT";      
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155, ERC1155Receiver)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function getLatestIdToListedToken() public view returns (ListedToken memory) {
        uint256 currentTokenId = _tokenIds.current();
        return listedTokens[currentTokenId];
    }

    function getListedTokenForId(uint256 tokenId) public view returns (ListedToken memory) {
        return listedTokens[tokenId];
    }

    function getCurrentToken() public view returns (uint256) {
        return _tokenIds.current();
    }

    //The first time a token is created, it is listed here
    function mint(string memory _uri, uint256 price, uint256 amount) public payable returns (uint) {
        require(price > 0, "Make sure the price isn't negative");

        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
            
        _mint(address(this), tokenId, amount, "");
        tokenURI[tokenId] = _uri;
        emit URI(_uri, tokenId);

        listedTokens[tokenId] = ListedToken(
            payable(msg.sender),
            price,
            true
        );

        return tokenId;
    }
    
    function buy(uint256 tokenId, uint256 amount) public payable {
        this.safeTransferFrom(address(this), msg.sender, tokenId, amount, "");
        
        if(balanceOf(address(this), tokenId) == 0) {
            delete listedTokens[tokenId];
        }
    }

}
