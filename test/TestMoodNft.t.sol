// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "@forge/src/Test.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";

contract TestMoodNft is Test {
    DeployMoodNft deployMoodNft;
    MoodNft moodNft;

    address public bob = makeAddr("bob");
    address public alice = makeAddr("alice");
    uint256 constant GAS_MONEY = 1 ether;

    function setUp() public {
        deployMoodNft = new DeployMoodNft();
        moodNft = deployMoodNft.run();
    }
    /*//////////////////////////////////////////////////////////////
                                  MINT
    //////////////////////////////////////////////////////////////*/

    modifier bobMintedToken(){
        hoax(bob, GAS_MONEY);
        moodNft.mint();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               FLIP MOOD
    //////////////////////////////////////////////////////////////*/
    function test_flipMood() public bobMintedToken{
        hoax(bob, GAS_MONEY);
        moodNft.flipMood(0);
        assert(moodNft.getTokenOwnerMood(0) == MoodNft.Mood.SAD);
    }

    function test_NonOwnerCannotFlipMood() public bobMintedToken{
        vm.expectRevert(MoodNft.MoodNft__CantFlipMoodIfNotOwner.selector);
        hoax(alice, GAS_MONEY);
        moodNft.flipMood(0);
    }

    /*//////////////////////////////////////////////////////////////
                                TOKENURI
    //////////////////////////////////////////////////////////////*/

    function test_ImageUri() public bobMintedToken{
        string memory test = moodNft.tokenURI(0);
        console.log("tokenURI: %s", test);
    }
}