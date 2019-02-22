pragma solidity ^0.5.3;

import "./owner.sol";

contract Shitcoin is Ownable{
    address _admin;

    constructor(address admin) public{
        _admin = admin;
    }
}
