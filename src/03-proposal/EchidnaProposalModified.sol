// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./ProposalModified.sol";
// import "forge-std/Test.sol";


contract EchidnaProposalModified {

    address[] public votersList;
    ProposalModified public proposal;
    uint256 public MSG_VALUE = 10000000000000000000;

    event ProposalBalance(uint256);

    constructor() payable {
        votersList.push(address(0x1000000000000000000000000000000000000000));
        votersList.push(address(0x2000000000000000000000000000000000000000));
        votersList.push(address(0x3000000000000000000000000000000000000000));
        votersList.push(address(0x4000000000000000000000000000000000000000));
        votersList.push(address(0x5000000000000000000000000000000000000000));

        proposal = new ProposalModified{value: MSG_VALUE}(votersList);

        assert(proposal.getTotalAllowedVoters() == votersList.length);
        assert(address(proposal).balance == MSG_VALUE);
        // console.log("This is the bal" , address(proposal).balance);
    }

    // function test_checkBal() public view {
    //     assert(proposal.getTotalAllowedVoters() == votersList.length);
    // }

    function echidna_check_Balance() public  returns(bool) {
        uint256  balance = address(proposal).balance;
        emit ProposalBalance(balance);

        if(proposal.isActive()){
            return (address(proposal).balance == MSG_VALUE);
        }
        else{
            return (address(proposal).balance == 0);
        }
    }


    function echidna_check_Votes() public  returns(bool){
        uint256  balance = address(proposal).balance;
        emit ProposalBalance(balance);
        
        if(!proposal.isActive()){
            address[] memory votesFor = proposal.votersFor();
            address[] memory votesAgainst = proposal.votersAgainst();

            if(votesFor.length > votesAgainst.length){
                for(uint256 i =0; i < votesAgainst.length; i++){
                    return votesAgainst[i].balance == 0;
                }
            }
            // (votesFor.length < votesAgainst.length)
            else{
                return (proposal.s_creator().balance == MSG_VALUE);
            }
        }
        return true;
    }


    receive() external payable {}
}