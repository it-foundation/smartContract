//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import "./ITToken.sol";

//The structure to store info about a listed token
struct ListedToken {
    uint256 tokenId;
    string uri;
    address payable seller;
    uint256 price;
    uint256 amount;
    bool isListed;
}

contract NFTMarketplace is ERC1155, Ownable, ERC1155Holder {
    using Counters for Counters.Counter;
    Counters.Counter internal _tokenIds;
    
    string public name;
    string public symbol;
    ITToken public _itt;

    //the event emitted when a token is successfully listed
    event TokenListedSuccess (
        uint256 indexed tokenId,
        address owner,
        address seller,
        uint256 price,
        uint256 amount,
        bool isListed
    );

    // tokenId => ListedToken
    mapping(uint256 => ListedToken) internal listedTokens;
    // tokenId => uri
    mapping(uint => string) public tokenURI;

    constructor(ITToken itt) ERC1155("") {
        name = "ShopIt";
        symbol = "IT";
        _itt = itt;
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
            tokenId,
            _uri,
            payable(msg.sender),
            price,
            amount,
            true
        );

        return tokenId;
    }
    


    function getMyNFTs() public view returns (ListedToken[] memory) {
        uint totalItemCount = _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;
        uint currentId;
        //Important to get a count of all the NFTs that belong to the user before we can make an array for them
        for(uint i=0; i < totalItemCount; i++)
        {
            if(listedTokens[i+1].seller == msg.sender){
                itemCount += 1;
            }
        }

                //Once you have the count of relevant NFTs, create an array then store all the NFTs in it
        ListedToken[] memory items = new ListedToken[](itemCount);
        for(uint i=0; i < totalItemCount; i++) {
            if(listedTokens[i+1].seller == msg.sender) {
                currentId = i+1;
                ListedToken storage currentItem = listedTokens[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }

        return items;
    }

    function getAllNFTs() public view returns (ListedToken[] memory) {
        uint nftCount = _tokenIds.current();
        ListedToken[] memory tokens = new ListedToken[](nftCount);
        uint currentIndex = 0;
        uint currentId;
        //at the moment currentlyListed is true for all, if it becomes false in the future we will 
        //filter out currentlyListed == false over here
        for(uint i=0;i<nftCount;i++)
        {
            currentId = i + 1;
            ListedToken storage currentItem = listedTokens[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex += 1;
        }
        //the array 'tokens' has the list of all NFTs in the marketplace
        return tokens;
    }



    function buy(uint256 tokenId, uint256 amount) public payable {

        ListedToken memory listedToken = listedTokens[tokenId];
        require(msg.sender.balance >= listedToken.price);

        this.safeTransferFrom(address(this), msg.sender, tokenId, amount, "");
        
        _itt.transfer(msg.sender, listedToken.seller, listedToken.price);
        


        listedTokens[tokenId].amount = listedTokens[tokenId].amount - amount;

        if(balanceOf(address(this), tokenId) == 0) {
            delete listedTokens[tokenId];
        }


    }

}
