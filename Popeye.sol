// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./PopeyeInterface.sol";

contract Popeye is PopeyeInterface {

    string constant private NAME = "Popeye";
    string constant private SYMBOL = "POPEYE";
    uint8 constant private DECIMALS = 18;
	uint256 constant private TOTAL_SUPPLY = 1929 * (10 ** uint(DECIMALS));

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;
    
    constructor() {
		balances[msg.sender] = TOTAL_SUPPLY;
	}

    function name() external pure override returns (string memory) { return NAME; }
    function symbol() external pure override returns (string memory) { return SYMBOL; }
    function decimals() external pure override returns (uint8) { return DECIMALS; }
    function totalSupply() external pure override returns (uint256) { return TOTAL_SUPPLY; }

    function balanceOf(address user) external view override returns (uint256 balance) {
        return balances[user];
    }

    function transfer(address to, uint256 amount) public override returns (bool success) {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool success) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address user, address spender) external view override returns (uint256 remaining) {
        return allowed[user][spender];
    }

    function transferFrom(address from, address to, uint256 amount) external override returns (bool success) {
        uint256 _allowance = allowed[from][msg.sender];
        if (_allowance != type(uint256).max) {
            allowed[from][msg.sender] = _allowance - amount;
        }
        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }
}
