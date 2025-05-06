// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeETH is Ownable {

    uint256 public balance;
    address public tokenAddress;
    event Deposit(address indexed depositer, uint256 amount);

    constructor(address _tokenAddress) Ownable(msg.sender){ 
        tokenAddress = _tokenAddress;
    }


    mapping(address => uint256) public pendingBalances;

    function lock(IERC20 _tokenAddress, uint256 _amount) public onlyOwner{
        require(address(_tokenAddress) == tokenAddress);
        require(_tokenAddress.allowance(msg.sender, address(this)) >= _amount, "Allowance not enough");
        require(_tokenAddress.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        emit Deposit(msg.sender, _amount);
    }

    function unlock(IERC20 _tokenAddress, uint256 _amount) public{
        require(address(_tokenAddress) == tokenAddress);
        require(pendingBalances[msg.sender]>= _amount, "Not enough balance to unlock");
        pendingBalances[msg.sender] -= _amount;
        _tokenAddress.transfer(msg.sender, _amount);

    }

    function burnedOnOtherSide(address userAddress, uint256 _amount) public onlyOwner{
        pendingBalances[userAddress] += _amount;
    }

}