// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AdNFTMarketplace is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    // Counter for assigning unique token IDs
    Counters.Counter private _tokenIds;

    // Structure to store advertisement details associated with an NFT
    struct AdDetails {
        string companyName;
        string videoUrl;
        string bannerUrl;
        // Can be replaced with a more generic media type if needed
        // You can add more details like description, target audience, etc.
    }

    // Mapping to store AdDetails for each token ID
    mapping(uint256 => AdDetails) public adDetails;

    mapping(uint256 => uint256) public listingPrices;

    address public marketplaceFeeRecipient;

    uint256 public marketplaceFeePercentage;

    event NFTListed(uint256 indexed tokenId, uint256 price);

    constructor() ERC721("AdNFT", "ADNFT") Ownable(msg.sender) {}

    // Function to create a new NFT with advertisement details
    function createAdNFT(
        string memory uri,
        AdDetails memory details
    ) public onlyOwner {
        uint256 tokenId = Counters.current(_tokenIds);
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
        adDetails[tokenId] = details;
        Counters.increment(_tokenIds);
    }

    // Function to list an NFT for sale (set a price)
    // You'll need to implement a pricing mechanism and manage sale state (available/sold)
    function listNFT(uint256 tokenId, uint256 price) public onlyOwner {
        // Implement logic to set the price and mark the NFT as listed for sale
        // Ensure the caller (msg.sender) owns the NFT
        require(ownerOf(tokenId) == msg.sender, "Only owner can list NFT");

        // Prevent re-listing of already listed NFTs
        require(listingPrices[tokenId] == 0, "NFT already listed");

        emit NFTListed(tokenId, price);
        // Set the listing price for the provided tokenId
        listingPrices[tokenId] = price;
    }

    // Function to buy a listed NFT (requires a payment system integration)
    // You'll need to integrate with an external payment system (e.g., oracle)
    function buyNFT(uint256 tokenId) public payable {
        // Implement logic to handle purchase using the payment system
        // Transfer ownership of the NFT to the buyer
        require(listingPrices[tokenId] > 0, "NFT not listed for sale");
        require(msg.value >= listingPrices[tokenId], "Insufficient payment");

        address seller = ownerOf(tokenId);
        uint256 marketplaceFee = (msg.value * marketplaceFeePercentage) / 100;
        uint256 sellerProceeds = msg.value - marketplaceFee;

        // Transfer funds (replace with actual payment system integration)
        payable(seller).transfer(sellerProceeds);
        payable(marketplaceFeeRecipient).transfer(marketplaceFee);

        // Transfer ownership of the NFT
        _transfer(seller, msg.sender, tokenId);

        // Clear listing price
        delete listingPrices[tokenId];
    }

    // Function to display details of an NFT (including AdDetails)
    function getNFTDetails(
        uint256 tokenId
    )
        public
        view
        returns (address owner, string memory uri, AdDetails memory details)
    {
        owner = ownerOf(tokenId);
        uri = tokenURI(tokenId);
        details = adDetails[tokenId];
        return (owner, uri, details);
    }

    // The following functions are overrides required by Solidity

    function _burn(uint256 tokenId) internal virtual override(ERC721) {
        super._burn(tokenId);
        delete adDetails[tokenId];
        delete listingPrices[tokenId];
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
