// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {CodeToken} from "../src/CodeToken.sol";
import {CodeTokenFaucet} from "../src/CodeTokenFaucet.sol";

contract DeployCodeTokenFaucet is Script {
    CodeToken ct;
    CodeTokenFaucet ctFaucet;
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 * 10 ** 18;

    function run() external returns (CodeToken, CodeTokenFaucet) {
        vm.startBroadcast();
        ct = new CodeToken();
        ctFaucet = new CodeTokenFaucet(address(ct));
        ct.transferOwnership(address(ctFaucet));
        ct.transfer(address(ctFaucet), INITIAL_SUPPLY);
        vm.stopBroadcast();
        return (ct, ctFaucet);
    }
}
