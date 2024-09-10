// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title
 * @author
 * @notice
 * @dev
 */

/**
 * Imports
 */
import {ERC721} from "@OZ/token/ERC721/ERC721.sol";
import {Base64} from "@OZ/utils/Base64.sol";
// @Order Imports, Interfaces, Libraries, Contracts

contract MoodNft is ERC721 {
    /**
     * Errors
     */
    error MoodNft__CantFlipMoodIfNotOwner();

    /**
     * Type Declarations
     */
    enum Mood {
        HAPPY,
        SAD
    }

    /**
     * State Variables
     */
    uint256 private s_tokenCounter;
    string private s_happyFaceImageUri;
    string private s_sadFaceImageUri;

    mapping(uint256 => Mood) private s_tokenIdToMood;
    mapping(uint256 => string) private s_tokenIdToUri;

    /**
     * Events
     */

    /**
     * Constructor
     */
    constructor(string memory _name, string memory _symbol, string memory _happyImageUri, string memory _sadImageUri)
        ERC721(_name, _symbol)
    {
        s_tokenCounter = 0;
        s_happyFaceImageUri = _happyImageUri;
        s_sadFaceImageUri = _sadImageUri;
    }

    /**
     * Modifiers
     */

    /**
     * Functions
     */
    // @Order recieve, fallback, external, public, internal, private
    receive() external payable {}
    fallback() external payable {}

    function mint() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 _tokenid) public {
        address actualOwner = _ownerOf(_tokenid);
        if (!_isAuthorized(actualOwner, msg.sender, _tokenid)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[_tokenid] == Mood.HAPPY) {
            s_tokenIdToMood[_tokenid] = Mood.SAD;
        } else {
            s_tokenIdToMood[_tokenid] = Mood.HAPPY;
        }
    }

    /**
     * Getter Functions
     */
    function getTokenOwnerMood(uint256 _tokenId) public view returns (Mood) {
        return s_tokenIdToMood[_tokenId];
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenID) public view override returns (string memory) {
        string memory imageUri;
        string memory _mood;
        if (s_tokenIdToMood[tokenID] == Mood.HAPPY) {
            _mood = "happy";
            imageUri = s_happyFaceImageUri;
        } else {
            _mood = "sad";
            imageUri = s_sadFaceImageUri;
        }
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "{\n",
                            '"name": "',
                            name(),
                            '",\n',
                            '"description": "',
                            _mood,
                            ' face",\n',
                            '"attributes": [{ "trait_type": "moodiness", "value": 100 }],\n',
                            '"image": "',
                            imageUri,
                            '"\n',
                            "}"
                        )
                    )
                )
            )
        );
    }
}
