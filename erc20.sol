// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ITToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {}

    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }
    
    function transfer(address from, address to, uint256 amount) public {
        _transfer(from, to, amount);
    }
}
