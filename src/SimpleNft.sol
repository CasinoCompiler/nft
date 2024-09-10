// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

/**
 * @title Simple NFT contract
 * @author CC
 * @notice
 * @dev
 */

/**
 * Imports
 */
import {ERC721} from "@OZ/token/ERC721/ERC721.sol";
// @Order Imports, Interfaces, Libraries, Contracts

/**
 * Errors
 */
contract SimpleNft is ERC721 {
    /**
     * Type Declarations
     */

    /**
     * State Variables
     */
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    /**
     * Events
     */

    /**
     * Constructor
     */
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        s_tokenCounter = 0;
    }

    /**
     * Modifiers
     */

    /**
     * Functions
     */
    // @Order recieve, fallback, external, public, internal, private

    function mint(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    /**
     * Getter Functions
     */
    function tokenURI(uint256 tokenID) public view override returns (string memory) {
        return s_tokenIdToUri[tokenID];
    }

    function getMintCount() public view returns (uint256) {
        return s_tokenCounter;
    }
}
