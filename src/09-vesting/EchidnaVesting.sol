// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;


import "./Vesting.sol";

interface IHevm {
    function  prank(address) external;
}

contract EchidnaVesting {
    
    Vesting public vesting;

    struct AllocationInput {
        address recipient;
        uint24 points;
        uint8  vestingWeeks;
    }

    address[] public recipientList;
    Vesting.AllocationInput[] public recipientData;

    uint24 public POINTS_PER_PERSON = 20_000;
    uint8 public ONE_WEEK = 1;

    IHevm hevm = IHevm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));

    // Approach 1 design with fixed point to everyone
    // Approach 2 design with dynamic allocation of point to everyone

    constructor () {
        recipientList.push(0x1000000000000000000000000000000000000000);
        recipientList.push(0x2000000000000000000000000000000000000000);
        recipientList.push(0x3000000000000000000000000000000000000000);
        recipientList.push(0x4000000000000000000000000000000000000000);
        recipientList.push(0x5000000000000000000000000000000000000000);

        // AllocationInput memory user1;
        // Vesting.AllocationInput[] memory data;

        for(uint256 i=0; i < 5; i++){
            Vesting.AllocationInput memory user;
            user.recipient = recipientList[i];
            user.points = POINTS_PER_PERSON;
            user.vestingWeeks = ONE_WEEK;
            recipientData.push(user);
        }

        vesting = new Vesting(recipientData);
    }


    function echidna_total_points_should_be_constant() public view returns(bool) {

        uint24 sumOfPoints;
        for(uint256 i = 0 ; i < 5;i++) {
            // Vesting.AllocationData memory data =  vesting.allocations([recipientList[i]]);
            // Vesting.AllocationData memory data = vesting.allocations(recipientList[i]);
           ( uint24 points,,) = vesting.allocations(recipientList[i]);
            sumOfPoints += points;
        }

        return (sumOfPoints == vesting.TOTAL_POINTS_PCT());
    }

    function between(uint256 value,uint256 min, uint256 max) public pure returns(uint256){
        return min + (value % (max - min + 1));
    }

    // transferPoints(address to, uint24 points)
    function handler(uint256 recipient, uint256 sender, uint24 points) public {
        
        address toAddress = recipientList[between(recipient, 0, recipientList.length)];
        address senderAddress = recipientList[between(sender, 0, recipientList.length)];

        (uint24 mPoints, , ) = vesting.allocations(senderAddress);
        points = uint24(between(points, 1, mPoints));

        require(points != 0);
        hevm.prank(senderAddress);
        vesting.transferPoints(toAddress,points);
    }

}
