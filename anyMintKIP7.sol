// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/klaytn/klaytn-contracts/blob/master/contracts/KIP/token/KIP7/KIP7.sol";

// if theres is error when compiling go to the file with error and replace the import github with the 
// actual link of the file from klaytn repo (get reference from the above link its the same repo above)


//deployed smart contract address is 0xE60e0C77A7Aa70Aaf9B80bae0BfadCb4A87693aD



contract KIP7Token is KIP7 {

   

    constructor()

    KIP7("TestCoin5", "tc5") {     

    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount * 10**uint(decimals()));
    }

}



