// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
// Transferring tokens: Players should be able to transfer their tokens to others.
// Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
// Checking token balance: Players should be able to check their token balance at any time.
// Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.

// comment --> 

// Map items with names that require a specific amount of DegenToken to be redeemed through 
// the redeem function.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, ERC20Burnable {
    address public owner;

    constructor() ERC20("Degen", "DGN") {
        owner = msg.sender;
        
        initializeItems();
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        owner = newOwner;
    }

    // a struct to store item 
    struct Item {
        string name;
        uint256 tokenCost;
    }

    // Mapping 
    mapping(uint8 => Item) public items;

    // Add items --> mapping
    function addItem(uint8 itemId, string memory itemName, uint256 cost) public onlyOwner {
        items[itemId] = Item(itemName, cost);
    }

    // Initialize items
    function initializeItems() public onlyOwner {
        addItem(1, "Sword", 10);
        addItem(2, "Shield", 5);
        
    }

    // Minting new tokens: 
    // The platform should be able to create new tokens and distribute them to players as
    //  rewards. Only the owner can mint tokens.
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount); 
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    // Checking token balance: 
    // Players should be able to check their token balance at any time.

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }
    
    // Transferring tokens: Players should be able to transfer their tokens to others.
    function transferTokens(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Not enough DGN Tokens");
        _transfer(msg.sender, _receiver, _value);
    }

    // Burning tokens: Anyone should be able to burn tokens, 
    // that they own, that are no longer needed.

    function burnTokens(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Not enough DGN");
        _burn(msg.sender, _value);
    }

    // Redeeming tokens: Players should be able to redeem their tokens for items 
    // in the in-game store.
    function redeemTokens(uint8 itemId) external returns (bool) {
        require(items[itemId].tokenCost > 0, "Item does not exist");
        require(balanceOf(msg.sender) >= items[itemId].tokenCost, "Not enough Degen Tokens");

        // Transfer the tokens from the user to the owner
        _transfer(msg.sender, owner, items[itemId].tokenCost);

        // Emit an event for item redemption
        emit ItemRedeemed(msg.sender, items[itemId].name, items[itemId].tokenCost);

        return true;
    }

    // Event for item redemption
    event ItemRedeemed(address indexed user, string itemName, uint256 tokenCost);
}
