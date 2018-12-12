pragma solidity ^0.4.24;

import { ERC721Full } from "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";

import "./ChildToken.sol";

contract ChildERC721 is ChildToken, ERC721Full {

  // constructor
  constructor (address _token, string name, string symbol) ERC721Full(name, symbol)
    public 
    {
    require(_token != address(0));

    token = _token;
  }

  /**
   * Deposit tokens
   *
   * @param user address for address
   * @param tokenId token balance
   */
  function deposit(address user, uint256 tokenId) public onlyOwner {
    // check for amount and user
    require(user != address(0x0));
    uint256 input = balanceOf(user);

    _mint(user, tokenId);

    require(ownerOf(tokenId) == user);

    // deposit event
    emit Deposit(token, user, tokenId, input, balanceOf(user));
  }

  /**
   * Withdraw tokens
   *
   * @param tokenId tokens
   */
  function withdraw(uint256 tokenId) public {
    require(ownerOf(tokenId) == msg.sender);

    address user = msg.sender;
    uint256 input1 = balanceOf(user);

    _burn(user, tokenId);

    // withdraw event
    emit Withdraw(token, user, tokenId, input1, balanceOf(user));
  }

  function transferFrom(address from, address to, uint256 tokeId) public {
    uint256 input1 = balanceOf(from);
    uint256 input2 = balanceOf(to);

    // actual transfer
    super.transferFrom(from, to, tokeId);

    // log balance
    emit LogTransfer(
      token,
      from,
      to,
      tokeId,
      input1,
      input2,
      balanceOf(from),
      balanceOf(to)
    );
  }
  
}
