// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {CodeToken} from "../../src/CodeToken.sol";
import {CodeTokenFaucet} from "../../src/CodeTokenFaucet.sol";
import {DeployCodeTokenFaucet} from "../../script/DeployCodeTokenFaucet.s.sol";

contract CodeTokenFaucetTest is Test {
    DeployCodeTokenFaucet deployer;
    CodeToken ct;
    CodeTokenFaucet ctFaucet;
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 * 10 ** 18;
    address HYBRID = makeAddr("hybrid");

    function setUp() public {
        deployer = new DeployCodeTokenFaucet();
        (ct, ctFaucet) = deployer.run();
    }

    function testCantransferOwnershipAndMintedTokens() public view {
        assertEq(ct.owner(), address(ctFaucet));
        assertEq(ct.balanceOf(address(ctFaucet)), INITIAL_SUPPLY);
    }
}
