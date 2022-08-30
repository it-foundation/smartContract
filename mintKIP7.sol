// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/klaytn/klaytn-contracts/blob/master/contracts/KIP/token/KIP7/KIP7.sol";

contract KIP7Token is KIP7 {

    mapping(address => bool) controllers;

    constructor()

    KIP7("TestCoin4", "tc4") {     

    }

    function mint(address to, uint256 amount) external {
        require(controllers[msg.sender], "Only controllers can mint");
        _mint(to, amount * 10**uint(decimals()));
    }

   

    function addController(address controller) public{
    controllers[controller] = true;
  }

  function removeController(address controller) public{
    controllers[controller] = false;
  }
}


