// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;


import "./EchidnaTokenSale.sol";

contract AdvanceEchdinaTest is EchidnaTokenSale {

    constructor() payable EchidnaTokenSale() {
    }

    function buy(uint256 amountToBuy) public {
        hevm.prank(msg.sender);
        tSale.buy(amountToBuy);
    }

    function endSale() public {
        hevm.prank(msg.sender);
        tSale.endSale();
    }
}