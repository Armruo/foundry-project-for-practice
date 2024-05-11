// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


contract StakeContract {
    struct Stake {
        uint256 amount;
        uint256 unlockTime;
    }

    mapping(address => Stake) public stakers;
    SLToken public slToken;

    constructor(SLToken _slToken) {
        slToken = _slToken;
    }

    function stake(uint256 amount, uint256 lockTime) external {
        require(amount > 0, "Cannot stake 0");
        require(slToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        uint256 unlockTime = block.timestamp + lockTime;
        stakers[msg.sender] = Stake(amount, unlockTime);
    }

    function unstake() external {
        Stake memory userStake = stakers[msg.sender];
        require(userStake.amount > 0, "No stake to withdraw");
        require(block.timestamp >= userStake.unlockTime, "Stake still locked");
        uint256 amount = userStake.amount;
        delete stakers[msg.sender];
        require(slToken.transfer(msg.sender, amount), "Transfer failed");
    }
}
