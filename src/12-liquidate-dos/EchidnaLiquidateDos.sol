// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./LiquidateDos.sol";
import "forge-std/Test.sol";

interface IHevm {
    function  prank(address) external;
}
event variables(bool ghostVariables, bool contractVariables);

contract EchidnaLiquidateDos is Test {

    LiquidateDos liquidateDos;

    address[] usersList;

    mapping (address user => uint8 ) public isUserActiveInAnyMarket;
    mapping (address user => mapping(uint8 => bool)) public isUserActiveInMarket;

    bool liquidateUnexpectedError;

    IHevm hevm = IHevm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));

    constructor() {

        usersList.push(0x1000000000000000000000000000000000000000);
        usersList.push(0x2000000000000000000000000000000000000000);
        usersList.push(0x3000000000000000000000000000000000000000);
        usersList.push(0x4000000000000000000000000000000000000000);
        usersList.push(0x5000000000000000000000000000000000000000);
        usersList.push(0x6000000000000000000000000000000000000000);

        liquidateDos =  new LiquidateDos();
    }

    function between(uint256 value,uint256 min, uint256 max) internal pure returns(uint256){
        return min + (value % (max - min));
    }

    function handler_toggleLiquidations(bool toggle) public {
        liquidateDos.toggleLiquidations(toggle);
    }
    
    function handler_openPosition(uint8 value, uint8 userIndex) public {
        require(value > 0 && value <= 10);

        address user = usersList[between(userIndex, 0, usersList.length)];
        // @audit you'll add the try catch block here. because thier is a revert statement
        hevm.prank(user);
        liquidateDos.openPosition(value);

        ++isUserActiveInAnyMarket[user];
        isUserActiveInMarket[user][value] = true;
    }

    function handler_liquidate(uint8 value) public {
        uint256 val = between(value, 0 , usersList.length);
        address user = usersList[val];
        try liquidateDos.liquidate(user) {
            delete isUserActiveInAnyMarket[user];

            for(uint8 i = liquidateDos.MIN_MARKET_ID(); i<= liquidateDos.MAX_MARKET_ID(); i++) {
                delete isUserActiveInMarket[user][i];
            }
        }
        catch(bytes memory err){
            bytes4[] memory allowedErrors = new bytes4[](2);

            allowedErrors[0] = ILiquidateDos.LiquidationsDisabled.selector;
            allowedErrors[1] = ILiquidateDos.LiquidateUserNotInAnyMarkets.selector;
           
           if(_unexpectedErrors(bytes4(err) ,allowedErrors)){
                liquidateUnexpectedError = true;
           }
        }

    }

    function _unexpectedErrors(bytes4 caughtErrorByTheSmartContract, bytes4[] memory allowedErrors) internal pure returns(bool unexpectedError) {
        for(uint8 i; i< allowedErrors.length; i++){
            if(caughtErrorByTheSmartContract == allowedErrors[i]){
                // Because since the error was expected that's why it isn't unexpected
                return false;
            }
        }
        return true;
    }

    function echidna_users_should_be_present_in_same_markets() public returns(bool) {

        for(uint256 i; i< usersList.length; i++){
            address user = usersList[i];

            if(isUserActiveInAnyMarket[user] != 0) {
                for(uint8 j = liquidateDos.MIN_MARKET_ID(); j<= liquidateDos.MAX_MARKET_ID(); j++){
                    
                    bool activeInGhostVariables = isUserActiveInMarket[user][j];
                    bool activeInTheContract = liquidateDos.userActiveInMarket(user, j);
                    emit variables(activeInGhostVariables, activeInTheContract);

                    if(activeInGhostVariables != activeInTheContract){
                        return false;
                    }
                }
            }
        }

        return true;
    }


    function echidna_liquidating_users_should_not_fail() public view returns(bool){
        return (liquidateUnexpectedError == false);
    }



}


    // function handler_openPosition(uint8 value, uint8 userIndex) public {
    //     require(value > 0 && value <= 10);

    //     address user = usersList[between(userIndex, 0, usersList.length - 1)];
    //     // @audit you'll add the try catch block here. because thier is a revert statement
    //     hevm.prank(user);
    //     liquidateDos.openPosition(value);

    //     ++isUserActiveInAnyMarket[user];
    //     isUserActiveInMarket[user][value] = true;
    // }



    //  function handler_openPosition(uint8 value, uint8 userIndex) public {
    //     require(value > 0 && value <= 10);

    //     address user = usersList[between(userIndex, 0, usersList.length)];
    //     // @audit you'll add the try catch block here. because thier is a revert statement
    //     hevm.prank(user);
    //     try liquidateDos.openPosition(value) {
    //         ++isUserActiveInAnyMarket[user];
    //         isUserActiveInMarket[user][value] = true;
    //     }
    //     catch(bytes memory err){
    //         bytes4(err) == ILiquidateDos.UserAlreadyInMarket.selector;
    //     }
    // }