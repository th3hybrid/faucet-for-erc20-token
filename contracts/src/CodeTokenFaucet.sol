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

    //functions
    constructor(address _codeToken) {
        i_codeToken = CodeToken(_codeToken);
    }

    function claim() public {
        //basically you can only request for token transfer once every 24 hours
        //checks if token to claim is available from current balance
        if (WITHDRAWAL_AMOUNT > IERC20(i_codeToken).balanceOf(address(this))) {
            revert CodeTokenFaucet__InsufficientBalance();
        }

        //checks if 24 hours has passed
        if (block.timestamp < s_timeLeftToClaim[msg.sender]) {
            revert CodeTokenFaucet__ClaimTimeNotComplete();
        }

        IERC20(i_codeToken).transfer(msg.sender, WITHDRAWAL_AMOUNT);
        //set the timestamp after the withdrawal and be able to check for each user
        s_timeLeftToClaim[msg.sender] = block.timestamp + 1 days;
    }
}
