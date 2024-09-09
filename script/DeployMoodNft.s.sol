// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Base64} from "@OZ/utils/Base64.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract DeployMoodNft is Script{
    MoodNft moodNft;
    string public name = "TokenOwnerMood";
    string public symbol = "MOOD";
    string public happyImageUri;
    string public sadImageUri;


    function run() public returns(MoodNft){
        string memory happySvg = vm.readFile("./images/happy.svg");
        happyImageUri = svgToImageUri(happySvg);
        string memory sadSvg = vm.readFile("./images/sad.svg");
        sadImageUri = svgToImageUri(sadSvg);
        vm.startBroadcast();
        moodNft = new MoodNft(name, symbol, happyImageUri, sadImageUri);
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageUri(string memory svg) public pure returns(string memory){
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL,svgBase64Encoded));
    }
}