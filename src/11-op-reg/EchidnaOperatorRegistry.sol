// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;


import "./OperatorRegistry.sol";

event Details(uint128 iVal,uint128 operatorID,address operatorAdd);

contract EchidnaOperatorRegistry  {


    OperatorRegistry operator;

    constructor() {
        operator = new OperatorRegistry();
    }

    // operatorIdToAddress
    // operatorAddressToId

    function echidna_operator_id_and_operator_address_mapping_should_be_same() public returns(bool) {
        // assert
        uint128 totalOperators = operator.numOperators();


        // operator.operatorAddressToId[]
        for(uint128 i=1; i<=totalOperators; i++){
            address operatorAdd = operator.operatorIdToAddress(i);

            uint128 operatorID = operator.operatorAddressToId(operatorAdd);

            if(i != operatorID){
                emit Details(i, operatorID, operatorAdd);
                return false;
            }
        }

        return true;
    }

}