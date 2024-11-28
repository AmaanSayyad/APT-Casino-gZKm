// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Roulette is ReentrancyGuard, Ownable {
    // Game Parameters
    uint256 public minBet = 0.01 ether;
    uint256 public maxBet = 1 ether;

    enum BetType {
        Number,
        Color,
        EvenOdd
    }

    struct Bet {
        uint256 amount;
        uint8 betValue; // Number (0-36) or Color (0: Black, 1: Red) or EvenOdd (0: Even, 1: Odd)
        BetType betType;
        bool resolved;
        uint256 result;
        uint256 payout;
    }

    mapping(address => Bet[]) public playerBets;

    // Events
    event BetPlaced(address indexed player, uint256 amount, BetType betType, uint8 betValue);
    event BetResolved(address indexed player, uint256 result, uint256 payout);

    // Constructor with Ownable's required argument
    constructor(address initialOwner) Ownable(initialOwner) {}

    // Modifier to check valid bet amount
    modifier validBet(uint256 amount) {
        require(amount >= minBet && amount <= maxBet, "Bet amount out of range");
        _;
    }

    // Place a bet
    function placeBet(uint8 betValue, BetType betType) external payable nonReentrant validBet(msg.value) {
        require(betType == BetType.Number || betType == BetType.Color || betType == BetType.EvenOdd, "Invalid bet type");

        if (betType == BetType.Number) {
            require(betValue >= 0 && betValue <= 36, "Invalid number");
        } else if (betType == BetType.Color) {
            require(betValue == 0 || betValue == 1, "Invalid color"); // 0: Black, 1: Red
        } else if (betType == BetType.EvenOdd) {
            require(betValue == 0 || betValue == 1, "Invalid even/odd value"); // 0: Even, 1: Odd
        }

        // Record the bet
        playerBets[msg.sender].push(Bet(msg.value, betValue, betType, false, 0, 0));
        emit BetPlaced(msg.sender, msg.value, betType, betValue);

        // Resolve the bet
        resolveBet();
    }

    // Generate random number
    function generateRandomNumber() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 37;
    }

    // Resolve a player's bet
    function resolveBet() internal {
        uint256 randomNumber = generateRandomNumber();
        Bet storage playerBet = playerBets[msg.sender][playerBets[msg.sender].length - 1];
        playerBet.result = randomNumber;
        playerBet.resolved = true;

        // Calculate payout
        if (playerBet.betType == BetType.Number && playerBet.betValue == randomNumber) {
            playerBet.payout = playerBet.amount * 36; // 35:1 payout
        } else if (playerBet.betType == BetType.Color && getColor(randomNumber) == playerBet.betValue) {
            playerBet.payout = playerBet.amount * 2; // 1:1 payout
        } else if (playerBet.betType == BetType.EvenOdd && getEvenOdd(randomNumber) == playerBet.betValue) {
            playerBet.payout = playerBet.amount * 2; // 1:1 payout
        }

        // Pay the player if they won
        if (playerBet.payout > 0) {
            payable(msg.sender).transfer(playerBet.payout);
        }

        emit BetResolved(msg.sender, randomNumber, playerBet.payout);
    }

    // Helper function to determine the color of a number
    function getColor(uint256 number) public pure returns (uint8) {
        if (number == 0) return 0; // Green (treated as Black for simplicity)
        uint8[18] memory redNumbers = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36];
        for (uint8 i = 0; i < redNumbers.length; i++) {
            if (redNumbers[i] == number) return 1; // Red
        }
        return 0; // Black
    }

    // Helper function to determine even or odd
    function getEvenOdd(uint256 number) public pure returns (uint8) {
        if (number == 0) return 0; // Treat zero as Even
        return number % 2 == 0 ? 0 : 1; // 0: Even, 1: Odd
    }

    // Fallback and receive functions
    fallback() external payable {}

    receive() external payable {}

    // Owner Functions
    function setMinBet(uint256 _minBet) external onlyOwner {
        minBet = _minBet;
    }

    function setMaxBet(uint256 _maxBet) external onlyOwner {
        maxBet = _maxBet;
    }

    function withdrawBalance() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
