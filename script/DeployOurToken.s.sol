// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../src/OurToken.sol";
import "forge-std/Script.sol";

contract DeployOurToken is Script {
    uint256 constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (OurToken) {
        vm.startBroadcast();
        OurToken ot = new OurToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return ot;
    }
}
