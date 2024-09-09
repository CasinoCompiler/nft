// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "@forge/src/Test.sol";
import {SimpleNft} from "../src/SimpleNft.sol";
import {DeploySimpleNft} from "../script/DeploySimpleNft.s.sol";

contract TestSimpleNft is Test {
    DeploySimpleNft public deploySimpleNft;    
    SimpleNft public simpleNft;

    address bob = makeAddr('bob');
    address alice = makeAddr('alice');
    uint256 constant GAS_MONEY = 1 ether;

    function setUp() public {
        deploySimpleNft = new DeploySimpleNft();
        simpleNft = deploySimpleNft.run();
    }
    /*//////////////////////////////////////////////////////////////
                                 SETUP
    //////////////////////////////////////////////////////////////*/

    function test_SetUpCorrectly() public view{
        bytes memory encodedExpected = abi.encodePacked(deploySimpleNft.name());
        bytes memory encodedActual = abi.encodePacked(simpleNft.name());
        // bytes32 hashedExpected = keccak256(encodedExpected);
        // bytes32 hashedActual = keccak256(encodedActual);

        assertEq(keccak256(encodedActual), keccak256(encodedExpected));    
    }
    /*//////////////////////////////////////////////////////////////
                                  MINT
    //////////////////////////////////////////////////////////////*/

    string public _tokenUriBernard = "QmUPjADFGEKmfohdTaNcWhp7VGk26h5jXDA7v3VtTnTLcW";
    string public _tokenUriPug = "QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8";

    modifier bobMintDog(){
        hoax(bob, GAS_MONEY);
        simpleNft.mint(_tokenUriBernard);
        _;
    }

        modifier bobAndAliceMintDog(){
        hoax(bob, GAS_MONEY);
        simpleNft.mint(_tokenUriBernard);
        hoax(alice, GAS_MONEY);
        simpleNft.mint(_tokenUriPug);
        _;

    }

    function test_firstMint() public bobMintDog{
        assert(simpleNft.balanceOf(bob) == 1);
        assert(keccak256(abi.encodePacked(_tokenUriBernard)) == keccak256(abi.encodePacked(simpleNft.tokenURI(0))));
    }

    function test_SecondMint() public bobAndAliceMintDog{
        assert(keccak256(abi.encodePacked(_tokenUriPug)) == keccak256(abi.encodePacked(simpleNft.tokenURI(1))));
    }

}