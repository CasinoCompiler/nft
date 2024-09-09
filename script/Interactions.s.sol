// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "@devops/src/DevOpsTools.sol";
import {SimpleNft} from "../src/SimpleNft.sol";
import {DeploySimpleNft} from "./DeploySimpleNft.s.sol";

contract InteractWithSimpleNft is Script{
    string public tokenUriPug = "QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8";

    function run() public {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("SimpleNft", block.chainid);
        mintNftOnContract(mostRecentDeployment);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        SimpleNft(contractAddress).mint(tokenUriPug);
        vm.stopBroadcast();
    }
}