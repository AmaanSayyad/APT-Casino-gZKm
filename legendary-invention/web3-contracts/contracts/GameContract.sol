// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract GameContract is Ownable, ReentrancyGuard {
    uint256 private gameFee;

    event GamePlayed(address indexed player, uint256 betAmount, uint256 randomResult, bool won);

    constructor(uint256 _gameFee) {
        gameFee = _gameFee;
    }

    function playGame(uint256 betAmount) external payable nonReentrant {
        require(msg.value >= gameFee, "Insufficient fee");

        // Generate pseudo-random number
        uint256 randomResult = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 100;
        bool won = randomResult > 50;

        emit GamePlayed(msg.sender, betAmount, randomResult, won);

        // Send reward if player wins
        if (won) {
            payable(msg.sender).transfer(betAmount * 2); // Example multiplier
        }
    }

    function updateGameFee(uint256 _gameFee) external onlyOwner {
        gameFee = _gameFee;
    }

    receive() external payable {}
}
