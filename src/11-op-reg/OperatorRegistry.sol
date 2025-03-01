// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract OperatorRegistry {
    uint128 public numOperators;

    mapping(uint128 operatorId      => address operatorAddress) public operatorIdToAddress;
    mapping(address operatorAddress => uint128 operatorId) public operatorAddressToId;

    // anyone can register their address as an operator
    function register() external returns(uint128 newOperatorId) {
        require(operatorAddressToId[msg.sender] == 0, "Address already registered");

        newOperatorId = ++numOperators;

        operatorAddressToId[msg.sender] = newOperatorId;
        operatorIdToAddress[newOperatorId] = msg.sender;
    }
    /*
        0x20 = 1
        1 = 0x20

        0x10 = 2
        2 = 0x10
    */

    // an operator can update their address
    function updateAddress(address newOperatorAddress) external {
        require(msg.sender != newOperatorAddress, "Updated address must be different");
        // @audit added a require statement to check if the new Address that is being added should not be registered
        require(operatorAddressToId[newOperatorAddress] == 0, "Address already registered");
        uint128 operatorId = _getOperatorIdSafe(msg.sender);

        operatorAddressToId[newOperatorAddress] = operatorId;
        operatorIdToAddress[operatorId] = newOperatorAddress;

        delete operatorAddressToId[msg.sender];
    }

    function _getOperatorIdSafe(address operatorAddress) internal view returns (uint128 operatorId) {
        operatorId = operatorAddressToId[operatorAddress];

        require(operatorId != 0, "Operator not registered");
    }
}
