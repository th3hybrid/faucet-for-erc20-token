// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {CodeToken} from "./CodeToken.sol";

/**
 * @title CodeToken Faucet contract
 * @author Emmanuel Oludare & Dan Harry
 * @notice This contract dispenses the CodeToken to users.
 */

contract CodeTokenFaucet {
    //error
    error CodeTokenFaucet__InsufficientBalance();
    error CodeTokenFaucet__ClaimTimeNotComplete();

    //state variables
    CodeToken private immutable i_codeToken;
    uint256 private constant WITHDRAWAL_AMOUNT = 1000 ether;
    mapping(address => uint256) private s_timeLeftToClaim;

    //events
    event TokensClaimed(
        address indexed claimant,
        uint256 amount,
        uint256 nextClaimTime
    );

    //functions
    constructor(address _codeToken) {
        i_codeToken = CodeToken(_codeToken);
    }

    function claim(address user) external {
        //basically you can only request for token transfer once every 24 hours
        //checks if token to claim is available from current balance
        if (WITHDRAWAL_AMOUNT > IERC20(i_codeToken).balanceOf(address(this))) {
            revert CodeTokenFaucet__InsufficientBalance();
        }

        //checks if 24 hours has passed
        if (s_timeLeftToClaim[user] > block.timestamp) {
            revert CodeTokenFaucet__ClaimTimeNotComplete();
        }

        IERC20(i_codeToken).transfer(user, WITHDRAWAL_AMOUNT);
        //set the timestamp after the withdrawal and be able to check for each user
        s_timeLeftToClaim[user] = block.timestamp + 1 days;
        emit TokensClaimed(user, WITHDRAWAL_AMOUNT, s_timeLeftToClaim[user]);
    }

    function getCTAddress() public view returns (address) {
        return address(i_codeToken);
    }

    function checkTimeLeftToClaim(address user) public view returns (uint256) {
        if (s_timeLeftToClaim[user] > block.timestamp) {
            return s_timeLeftToClaim[user] - block.timestamp;
        } else {
            return 0;
        }
    }
}
