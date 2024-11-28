// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CasinoTreasury {
    address public owner;
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function distributeRewards(address[] memory recipients, uint256[] memory amounts) external {
        require(msg.sender == owner, "Only owner can distribute rewards");
        require(recipients.length == amounts.length, "Mismatched input lengths");
        for (uint256 i = 0; i < recipients.length; i++) {
            payable(recipients[i]).transfer(amounts[i]);
        }
    }
}
