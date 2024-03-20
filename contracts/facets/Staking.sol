// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../libraries/AppStorage.sol";
import "../reward.sol";

contract Staking {
    AppStorage internal _s;
   

    function init(IERC20 _rewardToken) public {
         _s.rewardToken = IERC20(_rewardToken);
    }

    function stake(uint256 _amount) public {

        require(_amount > 0, "Amount must be greater than 0");
        require(
            IERC20(_s.ercAddress).transferFrom(
                msg.sender,
                address(this),
                _amount
            ),
            "Transfer failed"
        );
        Staker storage st = _s.stakers[msg.sender];

        if (st.amountStaked == 0) {
            st.amountStaked = _amount;
            st.reward.reward;
            st.timeStaked = block.timestamp;
        } else {
            st.amountStaked += _amount;
        }
    }

    function calculateReward(
        address _user
    ) internal returns (uint) {

        Reward storage rw = _s.userReward[_user];


        rw.apy = 120;
         uint256 apyFraction = rw.apy * 1e18;
        rw.time = 365 days;

        rw.dailyRewardRate = (apyFraction / 100) / 365;
        Staker storage st = _s.stakers[_user];

        rw.reward =
            (st.timeStaked * rw.dailyRewardRate * st.amountStaked) /
            rw.time;

       rw.reward += st.userBalance[_user];
        

        return rw.reward;
    }

    function withdraw(uint _amount) public {

        address _user = msg.sender;
        Reward storage rw = _s.userReward[_user];
        Staker storage st = _s.stakers[_user];

        calculateReward(_user); // Calculate rewards

        require(rw.reward >= _amount, "You don't have enough rewards yet!");
        st.userBalance[_user] -= _amount;

        rw.reward -= _amount;

        require(_s.rewardToken.transfer(msg.sender, _amount), "not enough!!");
    }

    function getStakeamount() public view returns (uint _addr) {

        Staker storage st = _s.stakers[msg.sender];
        _addr = st.userBalance[msg.sender];
        return _addr;
    }
}
