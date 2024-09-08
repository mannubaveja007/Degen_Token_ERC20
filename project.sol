// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//1. Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
//2. Transferring tokens: Players should be able to transfer their tokens to others.
//3. Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
//4. Checking token balance: Players should be able to check their token balance at any time.
//5. Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.

contract DegenToken is ERC20 {
    struct Store {
        string name;
        uint256 price;
    }
    
    struct UserCollection {
        uint256 id;
    }
    address public owner;
    mapping(uint256 => Store) public redeemableNFT;
    mapping(address => mapping(uint256 => uint256)) public NFTsCollection;
    mapping(address => UserCollection[]) public userCollections;

    constructor() ERC20("Degen Token", "DEGEN") {
        owner = msg.sender;
        redeemableNFT[1] = Store("NFT: Eiffel Tower", 4400);
        redeemableNFT[2] = Store("NFT: Mona Lisa", 1000);
        redeemableNFT[3] = Store("NFT: Great Wall of China", 2000);
        redeemableNFT[4] = Store("NFT: Statue of Liberty", 3500);
        redeemableNFT[5] = Store("NFT: Mount Everest", 3900);
        redeemableNFT[6] = Store("NFT: Colosseum", 4100);
        redeemableNFT[7] = Store("NFT: Sydney Opera House", 6000);
        redeemableNFT[8] = Store("NFT: Big Ben", 7000);
        
    }
     modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function you can't");
        _; 
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function decimals() public view virtual override returns (uint8) {
        return 1;
    }

    function burn( uint256 val) public {
        require(balanceOf(msg.sender) >= val, "You don't have enough Degen tokens to burn");
        _burn(msg.sender, val);
    }

    function transferToken(address sender, address _receiver, uint256 val) external {
        require(balanceOf(sender) >= val, "You don't have enough Degen tokens to transfer");
        approve(sender, val);
        _transfer(sender, _receiver, val);
    }

    function redeemToken(uint256 NFTId) external payable {
        require(redeemableNFT[NFTId].price <= balanceOf(msg.sender), "Insufficient funds");
        require(balanceOf(msg.sender) >= redeemableNFT[NFTId].price, "You don't have enough Degen tokens to redeem");
        _burn(msg.sender, redeemableNFT[NFTId].price);
        NFTsCollection[msg.sender][NFTId] += 1;
        userCollections[msg.sender].push(UserCollection(NFTId));
    }
   
    function showUserCollection(address user) public view returns (uint256[] memory) {
        uint256[] memory userCollection = new uint256[](8);

        for (uint256 i = 1; i <= 8; i++) {
            userCollection[i-1] = NFTsCollection[user][i]; 
        }

        return userCollection;
    }



    function showStore() external pure returns (string memory) {
        return "Landmark: Eiffel Tower\n2. Artwork: Mona Lisa\n3. Structure: Great Wall of China\n4. Monument: Statue of Liberty\n5. Peak: Mount Everest\n6. Mausoleum: Taj Mahal\n7. Landmark: Hollywood Sign\n8. Amphitheater: Colosseum\n9. Building: Sydney Opera House\n10. Clock Tower: Big Ben";
    }
}
