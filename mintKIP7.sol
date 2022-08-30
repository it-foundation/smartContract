// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/klaytn/klaytn-contracts/blob/master/contracts/KIP/token/KIP7/KIP7.sol";

// if theres is error when compiling go to the file with error and replace the import github with the 
// actual link of the file from klaytn repo (get reference from the above link its the same repo above)


//latest smart contract address is 0x855c1E8326aa9A5B240027df14A7210455322c87

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


