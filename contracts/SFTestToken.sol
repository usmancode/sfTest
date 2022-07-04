// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SFTestToken is ERC20, Ownable {

    constructor(address _stakingAddress, uint256 _amount) ERC20("SFTestToken", "SFT") {
        _mint(_stakingAddress, _amount);
    }
}