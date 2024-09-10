// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {SimpleNft} from "../src/SimpleNft.sol";

contract DeploySimpleNft is Script {
    SimpleNft simpleNft;
    string public name = "doggo";
    string public symbol = "dog";

    //address deployerAddress = address(1);

    function run() external returns (SimpleNft) {
        vm.startBroadcast();
        simpleNft = new SimpleNft(name, symbol);
        vm.stopBroadcast();
        return simpleNft;
    }
}
