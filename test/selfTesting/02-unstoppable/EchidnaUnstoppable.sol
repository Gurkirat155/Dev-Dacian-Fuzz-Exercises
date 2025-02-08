// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import "../../../src/02-unstoppable/ReceiverUnstoppable.sol";
import "../../../src/02-unstoppable/UnstoppableLender.sol";
import "../../../src/TestToken.sol";
import "forge-std/Test.sol";

contract EchidnaUnstoppable is Test {

    TestToken public token;
    UnstoppableLender public pool;
    ReceiverUnstoppable public user;
    // uint256 initialMint, uint8 decimal

    uint256 public INITIAL_POOL_AMT = 1000000e18;
    uint256 public INITIAL_USER_AMT = 100e18;
    uint8 public DECIMALS = 18;

    constructor () payable {
        token = new TestToken(INITIAL_POOL_AMT + INITIAL_USER_AMT, DECIMALS);
        pool = new UnstoppableLender(address(token));
        user = new ReceiverUnstoppable(address(pool));
        console.log("Balance of user before transfer of pool " , token.balanceOf(address(pool)));
        console.log("Balance of user before transfer of user " , token.balanceOf(address(user)));
        token.approve(address(pool), INITIAL_POOL_AMT);
        pool.depositTokens(INITIAL_POOL_AMT);
        token.transfer(address(user), INITIAL_USER_AMT);
        console.log("Balance of user after transfer of pool " , token.balanceOf(address(pool))/1e18);
        console.log("Balance of user after transfer of user " , token.balanceOf(address(user))/1e18);
    }

    // function testBalance() public view{
    //     assert(token.balanceOf(address(pool)) == INITIAL_POOL_AMT);
    // }

    // function receiveTokens(address tokenAddress, uint256 amount) external {
    //     require(msg.sender == address(pool), "Sender must be pool");
    //     // Return all tokens to the pool
    //     require(
    //         IERC20(tokenAddress).transfer(msg.sender, amount),
    //         "Transfer of tokens failed"
    //     );
    // }

    function echidna_flashloan() public returns(bool){
        user.executeFlashLoan(10);
        return true;
    }

    function echidna_pool_bal_equal_token_pool_bal() public view returns(bool) {
        return(pool.poolBalance() == token.balanceOf(address(pool)));
    }

}