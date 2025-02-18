// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;


import "../TestToken3.sol";
import "./TokenSale.sol";
import "forge-std/Test.sol";

interface IHevm {
    function prank(address) external;
}


contract EchidnaTokenSale is Test{
    event creatorbal(uint256 bal);
    event soldTokens(uint256 soldtokens);
    event Sdecimals(uint256);
    event Bdecimals(uint256);

    IHevm hevm = IHevm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));

    uint256 constant MINT_S_TOKENS_AMT = 1000e18;
    // uint256 constant MINT_B_TOKENS_AMT = 2500e18;       // ---------------This changes from 18 to 6
    uint256 constant MINT_B_TOKENS_AMT = 2500e6;       // ---------------This changes from 18 to 6
    uint256 constant MIN_TOKENS_TO_BE_SOLD_AMT = 1000e18;
    uint256 constant MAX_S_TOKENS_PER_USER_SHOULD_HOLD  = 200e18;
    // uint256 constant MAX_B_TOKEN_BAL_PER_USER  = 500e18;        // ---------------This changes from 18 to 6
    uint256 constant MAX_B_TOKEN_BAL_PER_USER  = 500e6;        // ---------------This changes from 18 to 6

    TestToken3 public s_Token;  // This will be sent to the contract 
    TestToken3 public b_Token;

    TokenSale public tSale;

    address[]  public list;
    address public deployer = address(0x6000000000000000000000000000000000000000);

    /* 
    address[] memory allowList,
    address sellToken,
    address buyToken,
    uint256 maxTokensPerBuyer, == 20
    uint256 sellTokenAmount 
    */
    constructor () payable {
        list.push(address(0x1000000000000000000000000000000000000000));
        list.push(address(0x2000000000000000000000000000000000000000));
        list.push(address(0x3000000000000000000000000000000000000000));
        list.push(address(0x4000000000000000000000000000000000000000));
        list.push(address(0x5000000000000000000000000000000000000000));
        hevm.prank(deployer);
        s_Token = new TestToken3(MINT_S_TOKENS_AMT,18,"SELL TOKEN" , "ST");
        hevm.prank(deployer);
        // b_Token = new TestToken3(MINT_B_TOKENS_AMT,18,"BUY TOKEN" , "BT"); // ---------------This changes from 18 to 6
        b_Token = new TestToken3(MINT_B_TOKENS_AMT,6,"BUY TOKEN" , "BT"); // ---------------This changes from 18 to 6

        // assert(s_Token.balanceOf(address(this)) == 0);
        // assert(b_Token.balanceOf(address(this)) == 0);

        assert(s_Token.decimals()  == 18);
        // assert(b_Token.decimals() == 18);   // ---------------This changes from 18 to 6
        assert(b_Token.decimals() == 6);   // ---------------This changes from 18 to 6

        emit Sdecimals(s_Token.decimals());
        emit Bdecimals(b_Token.decimals());

        hevm.prank(address(this));
        tSale = new TokenSale(list,address(s_Token), address(b_Token), MAX_S_TOKENS_PER_USER_SHOULD_HOLD, MIN_TOKENS_TO_BE_SOLD_AMT);
        s_Token.approve(address(tSale), MINT_S_TOKENS_AMT);
        s_Token.transfer(address(tSale), MINT_S_TOKENS_AMT);

        assert(tSale.getTotalAllowedBuyers() == list.length);
        assert(tSale.getCreator() == address(this));
        assert(tSale.getMaxTokensPerBuyer() == MAX_S_TOKENS_PER_USER_SHOULD_HOLD);
        assert(tSale.getSellTokenAddress() == address(s_Token));
        assert(tSale.getBuyTokenAddress() == address(b_Token));
        assert(s_Token.balanceOf(address(tSale)) == MINT_S_TOKENS_AMT);
        // getSellTokenTotalAmount
        // getSellTokenSoldAmount

        for(uint256 i=0;i<list.length;i++){
            b_Token.approve(list[i], MAX_B_TOKEN_BAL_PER_USER);
            b_Token.transfer(list[i], MAX_B_TOKEN_BAL_PER_USER);

            assert(b_Token.balanceOf(list[i]) == MAX_B_TOKEN_BAL_PER_USER);
            hevm.prank(list[i]);
            b_Token.approve(address(tSale), type(uint256).max);

        }

    }


    function echidna_token_bal_should_be_zero_when_sale_ends() public view returns(bool) {
        if(tSale.getRemainingSellTokens() == 0){
            return (s_Token.balanceOf(address(tSale)) == 0);
        }
        return true;
    }

    address[] public listlocal ;



    function echidna_check_total_sold_tokens_equal_bought_tokens() public  returns(bool) {
        // address creator =  tSale.getCreator(); 
        // emit creatorbal(b_Token.balanceOf(address(creator)));
        // emit soldTokens(tSale.getSellTokenSoldAmount());
        // return (b_Token.balanceOf(address(creator)) == tSale.getSellTokenSoldAmount());

        uint256 soldAmount = tSale.getSellTokenSoldAmount();
        uint256 boughtBal  = b_Token.balanceOf(tSale.getCreator());

        // Adjust for decimal precision difference
        uint8 sellDecimals = s_Token.decimals();
        uint8 buyDecimals  = b_Token.decimals();

        if (sellDecimals > buyDecimals) {
            boughtBal *= 10 ** (sellDecimals - buyDecimals);
        } else if (buyDecimals > sellDecimals) {
            soldAmount *= 10 ** (buyDecimals - sellDecimals);
        }
        emit creatorbal(boughtBal);
        emit soldTokens(soldAmount);
        return (boughtBal == soldAmount);
    }

    function echidna_user_govt_token_bal_should_not_increase_more_than_max_tokens_per_user() public view returns(bool) {
        for(uint256 i=0; i<list.length;i++) {
            if (s_Token.balanceOf(list[i]) > MAX_S_TOKENS_PER_USER_SHOULD_HOLD) {
                return false; // If any address has more than MAX_TOKENS_PER_USER, fail the test
            }
        }
        return true;
    }
}
    // function testBalance() public  {
        
    //     address user1  = makeAddr("user1");
    //     address user2  = makeAddr("user2");
    //     address user3  = makeAddr("user3");
    //     address deployerFoundry  = makeAddr("deployerFoundry");
        
    //     listlocal.push(user1);
    //     listlocal.push(user2);
    //     listlocal.push(user3);

    //     TestToken3 s_Token_Local = new TestToken3(MINT_S_TOKENS_AMT,18,"SELL TOKEN" , "ST");
    //     TestToken3 b_Token_Local = new TestToken3(2500e18,18,"BUY TOKEN", "BT");

    //     console.log("This is decimals of the sell tokens", s_Token_Local.decimals());
    //     console.log("This is decimals of the buy tokens", b_Token_Local.decimals());
        // vm.prank(deployerFoundry);
        // TokenSale tSale_local = new TokenSale(listlocal ,address(s_Token_Local), address(b_Token_Local), MAX_S_TOKENS_PER_USER_SHOULD_HOLD, MIN_TOKENS_TO_BE_SOLD_AMT);
        // s_Token_Local.approve(address(tSale_local), MINT_S_TOKENS_AMT);
        // s_Token_Local.transfer(address(tSale_local), MINT_S_TOKENS_AMT);
        // console.log("Balance Of S tokens in the contract " , s_Token_Local.balanceOf(address(tSale_local)));
        // b_Token_Local.approve(user1, 500);
        // b_Token_Local.transfer(user1, 500);
        // vm.startPrank(user1);
        // // console.log("Token sale contract address" , address(tSale_local));
        // b_Token_Local.approve(address(tSale_local), 200);
        // tSale_local.buy(200);
        // vm.stopPrank();
        // address creator =  tSale_local.getCreator();
        // // Have to transfer some b_tokens to user also
        
        // console.log("Balance of buy tokens for Creator", b_Token_Local.balanceOf(address(creator)));
        // console.log("Balance of total sold tokens",tSale_local.getSellTokenSoldAmount());
    // }
    
    // function testCreatorBal() public view {
    //     // address creator =  tSale.getCreator();
    //     // uint256 boughtBal = b_Token.balanceOf((creator));
    //     // boughtBal *= 10 ** (18 - 6);
    //     console.log("This is decimals of the sell tokens", s_Token.decimals());
    //     console.log("This is decimals of the buy tokens", b_Token.decimals());
    //     // console.log("This is bought bal", boughtBal);
    //     // console.log(b_Token.balanceOf((creator)), "Balance of creator is");
    //     // console.log("Address this is" , address(this));
    //     // console.log("Creator is", creator);
    // }





