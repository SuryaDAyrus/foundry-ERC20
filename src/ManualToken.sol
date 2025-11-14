// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

contract ManualToken {
    mapping(address => uint256) public s_balances;

    function name() external pure returns (string memory) {
        return "ManualToken";
    }

    function totalSupply() external pure returns (uint256) {
        return 1000000;
    }
    function decimals() external pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return s_balances[_owner];
    }
   
    function transfer(address _to, uint256 _value) external returns (bool) {
        require(s_balances[msg.sender] >= _value, "Insufficient balance");
        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;
        return true;
    }
}