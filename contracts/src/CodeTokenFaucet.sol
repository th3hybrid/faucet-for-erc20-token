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
    //state variables
    CodeToken private immutable i_codeToken;

    //functions
    constructor(address _codeToken) {
        i_codeToken = CodeToken(_codeToken);
    }

    function withdraw() public {}
}
