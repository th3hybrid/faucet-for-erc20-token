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
    uint256 private constant WITHDRAWAL_AMOUNT = 1000 ether;
    address HYBRID = makeAddr("hybrid");

    function setUp() public {
        deployer = new DeployCodeTokenFaucet();
        (ct, ctFaucet) = deployer.run();
    }

    function testCantransferOwnershipAndMintedTokens() public view {
        assertEq(ct.owner(), address(ctFaucet));
        assertEq(ct.balanceOf(address(ctFaucet)), INITIAL_SUPPLY);
    }

    function testCanClaimToken() public {
        uint256 startingUserBalance = ct.balanceOf(HYBRID);
        ctFaucet.claim(HYBRID);
        uint256 endUserBalance = ct.balanceOf(HYBRID);
        assert(startingUserBalance == 0);
        assert(endUserBalance == WITHDRAWAL_AMOUNT);
    }

    function testCannotClaimUntilDurationComplete() public {
        ctFaucet.claim(HYBRID);
        vm.expectRevert(
            CodeTokenFaucet.CodeTokenFaucet__ClaimTimeNotComplete.selector
        );
        ctFaucet.claim(HYBRID);
    }

    function testCanClaimAgainAfterDuration() public {
        ctFaucet.claim(HYBRID);
        vm.warp(block.timestamp + 1 days);
        vm.roll(block.number + 3);
        ctFaucet.claim(HYBRID);
        assert(ct.balanceOf(HYBRID) == (WITHDRAWAL_AMOUNT + WITHDRAWAL_AMOUNT));
    }

    function testCantClaimIfBalanceNotEnough() public {
        vm.startPrank(address(ctFaucet));
        ct.transfer(HYBRID, INITIAL_SUPPLY);
        vm.stopPrank();
        vm.expectRevert(
            CodeTokenFaucet.CodeTokenFaucet__InsufficientBalance.selector
        );
        ctFaucet.claim(HYBRID);
    }

    function testCTAddressGetsSet() public view {
        assertEq(ctFaucet.getCTAddress(), address(ct));
    }

    function testCanCheckTimeLeft() public {
        ctFaucet.claim(HYBRID);
        assertEq(ctFaucet.checkTimeLeftToClaim(HYBRID), 1 days);
        vm.warp(block.timestamp + 1 days);
        vm.roll(block.number + 3);
        assertEq(ctFaucet.checkTimeLeftToClaim(HYBRID), 0);
    }
}
