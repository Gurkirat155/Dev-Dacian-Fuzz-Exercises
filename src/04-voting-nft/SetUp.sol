// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;


import "./VotingNftForFuzz.sol";

contract SetUp {
    // constructor(
    //     uint256 requiredCollateral,
    //     uint256 powerCalcTimestamp,
    //     uint256 maxNftPower,
    //     uint256 nftPowerReductionPercent) 
    //     ERC721("VNFT", "VNFT")
    //     Ownable(msg.sender) {

    //     // input sanity checks
    //     require(requiredCollateral > 0, "VNFT: required collateral must be > 0");
    //     require(powerCalcTimestamp > block.timestamp, "VNFT: power calc timestamp must be in the future");
    //     require(maxNftPower > 0, "VNFT: max nft power must be > 0");
    //     require(nftPowerReductionPercent > 0, "VNFT: nft power reduction must be > 0");
    //     require(nftPowerReductionPercent < PERCENTAGE_100, "VNFT: nft power reduction too big");

    //     s_requiredCollateral = requiredCollateral;
    //     s_powerCalcTimestamp = powerCalcTimestamp;
    //     s_maxNftPower        = maxNftPower;
    //     s_nftPowerReductionPercent = nftPowerReductionPercent;
    // }

    VotingNftForFuzz public votingNft;

    constructor() {
        // uint256 requiredCollateral = 1 ether;
        // uint256 powerCalcTimestamp = 1 day;
        // uint256 maxNftPower = 50%;
        // uint256 nftPowerReductionPercent = 10%;
    }
}