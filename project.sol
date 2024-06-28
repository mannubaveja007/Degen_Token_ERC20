// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


// Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
// Transferring tokens: Players should be able to transfer their tokens to others.
// Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
// Checking token balance: Players should be able to check their token balance at any time.
// Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    constructor() ERC20("Degen", "DGN") Ownable(msg.sender){}
// Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount); 
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }
// Checking token balance: Players should be able to check their token balance at any time.

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }
    
// Transferring tokens: Players should be able to transfer their tokens to others.

    function transferTokens(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Not enough DGN Tokens");
        _transfer(msg.sender, _receiver, _value);
    }
// Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.

    function burnTokens(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Not enough DGN");
        _burn(msg.sender, _value);
    }
// Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
    function redeemTokens(uint8 input) external returns (bool) {
        if (input == 1) {
            require(balanceOf(msg.sender) >= 10, "Not enough DGN Tokens");
            _transfer(msg.sender, owner(), 10);
            return true;
        }
        else if (input == 2) {
            require(balanceOf(msg.sender) >= 5, "Not enough Degen Tokens");
            _transfer(msg.sender, owner(), 5);
            return true;
        }
        else {
            return false;
        }
    }
}
