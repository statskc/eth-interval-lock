/*
    The FreeBSD Documentation License
    Copyright 1994-2021 The FreeBSD Project. All rights reserved.
*/

pragma solidity >=0.7.0 <0.9.0;

interface ERC20 { 
  function transfer(address to, uint256 value) external returns (bool);
}


contract IntervalLock {

    address payable private owner;

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    modifier onlyUnlocked() {
        if (((block.number % 2000000) <= 10000) || ((block.timestamp % 31536000 ) <= 86400)) {
            _;
            return;
        }
        revert();
    }

    constructor() payable {
        owner = msg.sender; 
    }

    fallback() external payable {
        
    }
    
    function withdraw(uint256 _amount) isOwner() onlyUnlocked() public {
        owner.transfer(_amount);
    }

    function withdrawToken(address _tokenContract, uint256 _amount) isOwner() onlyUnlocked() public {
       ERC20 token = ERC20(_tokenContract);
       token.transfer(owner, _amount);
    }
}