// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LWCA is ERC1155, Ownable, ERC1155Pausable, ERC1155Supply {
    uint256 public _totalSupply;
    uint256 public circulatingSupply;
    uint256 public price;
    address payable[] public nftOwners;

    IERC20 public USDT;
    constructor(
        address initialOwner)
        ERC1155("https://gateway.pinata.cloud/ipfs/QmNVc2R5vJeyEXktvvTrYPJxK1xVujvbCrQa7SAP32B8YK")
        Ownable(initialOwner)
    {
        _totalSupply = 12000;
        price = 2 * 10 ** 18;
        USDT = IERC20(0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee); //BUSD
        _mint(msg.sender, 0, 2000, "");
        circulatingSupply += 2000;
        
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(uint256 amount)
        public
        payable 
    {
        price = price * amount;
        require(USDT.balanceOf(msg.sender) >= price, "Insufficient funds");
        require(
            USDT.allowance(msg.sender, address(this)) >= price,
            "Insufficient allowance"
        );
        require(circulatingSupply < _totalSupply, "Supply exceed");
        circulatingSupply += amount;
        nftOwners.push(payable(msg.sender));
        require(circulatingSupply == nftOwners.length, "Some thing wrong");
        USDT.transferFrom(msg.sender, owner(), price);
        _mint(msg.sender, 0, amount, "");
    }

    function showHolders() public view returns (address payable[] memory)
    {
        return nftOwners;
    }
    
    function changePrice(uint256 newPrice) public onlyOwner
    {
        price = newPrice * 10**6;
    }

    function showPrice() external view returns(uint)
    {
        return price;
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Pausable, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }

      function withdrawStuckETH() external onlyOwner{
        require (address(this).balance > 0, "Can't withdraw negative or zero");
        payable(owner()).transfer(address(this).balance);
    }

    function removeStuckToken(address _address) external onlyOwner {
        require(_address != address(this), "Can't withdraw tokens destined for liquidity");
        require(IERC20(_address).balanceOf(address(this)) > 0, "Can't withdraw 0");

        IERC20(_address).transfer(owner(), IERC20(_address).balanceOf(address(this)));
    }  
}