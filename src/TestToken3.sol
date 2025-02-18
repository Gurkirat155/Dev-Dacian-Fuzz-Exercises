// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken3 is ERC20 {

    uint8 immutable private s_decimals;

    // mint initial supply to msg.sender. Used in test
    // setups so test setup can then distribute initial
    // tokens to different participants
    constructor(uint256 initialMint, uint8 decimal,string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, initialMint);
        s_decimals = decimal;
    }

    function decimals() public view override returns (uint8) {
        return s_decimals;
    }
}