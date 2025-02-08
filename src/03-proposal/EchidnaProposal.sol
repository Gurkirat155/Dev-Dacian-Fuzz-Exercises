// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./Proposal.sol";
// import "forge-std/Test.sol";


contract EchidnaProposal {

    address[] public votersList;
    Proposal public proposal;
    uint256 public MSG_VALUE = 10000000000000000000;
    event ProposalBalanceBefore(uint256 balance_Before);
    event ProposalBalanceAfter(uint256 balance_After);

    constructor() payable {
        votersList.push(address(0x1000000000000000000000000000000000000000));
        votersList.push(address(0x2000000000000000000000000000000000000000));
        votersList.push(address(0x3000000000000000000000000000000000000000));
        votersList.push(address(0x4000000000000000000000000000000000000000));
        votersList.push(address(0x5000000000000000000000000000000000000000));

        proposal = new Proposal{value: MSG_VALUE}(votersList);

        assert(proposal.getTotalAllowedVoters() == votersList.length);
        assert(address(proposal).balance == MSG_VALUE);
        // console.log("This is the bal" , address(proposal).balance);
    }

    // function test_checkBal() public view {
    //     assert(proposal.getTotalAllowedVoters() == votersList.length);
    // }

    function echidna_check_Balance() public returns(bool) {
        uint256  balance = address(proposal).balance;
        emit ProposalBalanceBefore(balance);

        if(proposal.isActive()){
            uint256  balanceAfter = address(proposal).balance;
            emit ProposalBalanceAfter(balanceAfter);
            return (address(proposal).balance == MSG_VALUE);
        }
        else{
            uint256  balanceAfter = address(proposal).balance;
            emit ProposalBalanceAfter(balanceAfter);
            return (address(proposal).balance == 0);
        }
    }

    receive() external payable {}
}