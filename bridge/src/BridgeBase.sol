// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBSUDT is IERC20{
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}


contract BridgeBase is Ownable {

    uint256 public balance;
    address public tokenAddress;

    constructor(address _tokenAddress) Ownable(msg.sender){ 
        tokenAddress = _tokenAddress; 
    }

    event Burn(address indexed burner, uint256 amount);
    mapping(address => uint256) public pendingBalances;


    function burn(IBSUDT _tokenaddress, uint256 _amount) public {
        require(address(_tokenaddress) == tokenAddress, "Invalid token address");
        _tokenaddress.burn(msg.sender, _amount);
        emit Burn(msg.sender, _amount);
        
    }   

    function widthdraw(IBSUDT _tokenaddress, uint256 _amount) public{
        require(pendingBalances[msg.sender]>= _amount, "Not enough balance to unlock");
        pendingBalances[msg.sender] -= _amount;
        _tokenaddress.mint(msg.sender, _amount);
    }


    function burnedOnOtherSide(address userAddress, uint256 _amount) public onlyOwner{
        pendingBalances[userAddress] += _amount;
    }
        // Logic to handle the burning of tokens on the other side of the bridge
    
}