// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/klaytn/klaytn-contracts/blob/master/contracts/KIP/token/KIP7/KIP7.sol";

contract KIP7Token is KIP7 {

   

    constructor()

    KIP7("TestCoin5", "tc5") {     

    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount * 10**uint(decimals()));
    }

}


