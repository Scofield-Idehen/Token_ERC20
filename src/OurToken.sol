// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract  OurToken is ERC20{
    constructor(uint256 initialsupply) ERC20("scofiedlTok", "ST"){
        _mint(msg.sender, initialsupply);
    }

}