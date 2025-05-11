// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

//proxy contract

contract Storage is Ownable{

    uint public num; //storage slot =0  , after adding ownable, storage slot  will become 2 so need to set num in other implementations in  storage slot 2
    address implementationAddress; // storage slot =1

    constructor(address _implementation) Ownable(msg.sender){
        num = 0;
        implementationAddress = _implementation;
    }

    function setnum(uint _num)public{
        (bool success, ) = implementationAddress.delegatecall(abi.encodeWithSignature("setNum(uint 256)", _num));

        require(success, "delegatecall failed");
    }

    //when the proxy contract is called, it will call the implementation contract
    function setImplementation(address _implementation) public onlyOwner(){
        implementationAddress = _implementation;
    }
}

//logic contract
contract Implementation{
    address public owner; // storage slot =0 ,adding dumyowner so that storage slot will become 1 for num
    uint public num;

    function setnum(uint _num) public{
        num = _num;
    }
}

//new logic contract created and its address is passed to the proxy contract