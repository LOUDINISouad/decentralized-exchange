// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";



contract MyToken is ERC20{
    constructor (string memory _name, string memory _symbol) ERC20 (_name,_symbol){
    }

    function mint(address to, uint256 amount) public virtual {
        _mint(to,amount);
    }
 
}
