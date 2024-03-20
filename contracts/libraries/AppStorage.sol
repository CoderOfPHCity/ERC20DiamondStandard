// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

    struct Staker {
        uint256 amountStaked;
        Reward reward;
        uint256 timeStaked;
        mapping (address => uint) userBalance;

    }

    struct Reward {
         uint apy; 
        uint time;
        uint dailyRewardRate;
        uint reward;

    }

    struct ERC20Storage {
    string _name;
    string _symbol;
    uint8 _decimal;
    uint256 _totalSupply;
    address _owner;

    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances;

}


struct AppStorage {
    mapping(address => ERC20Storage) ercdata;
    mapping (address => Reward) userReward;
    IERC20 ercAddress;
    IERC20 rewardToken;
    mapping(address => Staker) stakers;   

}




