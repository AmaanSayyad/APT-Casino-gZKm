// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiplayerSync {
    struct PlayerState {
        address player;
        uint256 positionX;
        uint256 positionY;
    }

    mapping(address => PlayerState) public playerStates;

    function updatePlayerState(uint256 positionX, uint256 positionY) external {
        playerStates[msg.sender] = PlayerState(msg.sender, positionX, positionY);
    }

    function getPlayerState(address player) external view returns (PlayerState memory) {
        return playerStates[player];
    }
}
