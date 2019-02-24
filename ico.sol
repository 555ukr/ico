pragma solidity ^0.5.3;

import "./owner.sol";
import "./erc20.sol";

contract Shitcoin is Ownable, ERC20{
  address public portalAddress;
  address public adminAddress;

  uint _state = 0; // 0 - defoult, 1 - private sale, 2 - presale, 3 - ico first round, 4 - ico second round, 5 - ico theird

  uint constant NOT_SALE = 0; // Not in sales
  uint constant PRIVATE_SALE = 1; // private sales
  uint constant PRESALE = 2; // presales
  uint constant IN_1ST_ICO = 3; // ICO 1st round
  uint constant IN_2ND_ICO = 4; // ICO 2nd round
  uint constant IN_3ND_ICO = 5; // ICO 2nd round

  uint public moneyAll = 0;
  uint totalRemainingTokensForSales = 500000000;

  uint public privateSalePrice;

  mapping(address => bool) public privateList;
  mapping(address => bool) public whiteList;

  event Print(uint val);

  constructor(address _adminAddr, address _portalAddr) public Ownable(){
    require(_adminAddr != address(0));
    require(_portalAddr != address(0));

    adminAddress = _adminAddr;
    portalAddress = _portalAddr;
  }

  function getCurrentState() public view returns (uint) {
    return _state;
  }

      modifier onlyOwnerOrAdminOrPortal() {
        require(msg.sender == _owner || msg.sender == adminAddress || msg.sender == portalAddress);
        _;
    }

    modifier onlyOwnerOrAdmin() {
        require(msg.sender == _owner || msg.sender == adminAddress);
        _;
    }

    function () external payable {
      uint state = getCurrentState();
      require(state != 0);

      bool isPrivate = privateList[msg.sender];
      if (isPrivate == true && state != NOT_SALE) {
          return issueTokensForPrivateInvestor();
      }
    //   if (state == PRESALE) {
    //       return issueTokensForPresale(state);
    //   }
    //   if (IN_1ST_ICO <= state && state <= IN_3RD_ICO) {
    //       return issueTokensForICO(state);
    //   }
      revert();
    }

    function issueTokensForPrivateInvestor() internal{
        issueTokens(privateSalePrice);
    }

    function issueTokens(uint256 _price) private {

        uint tokenAmount = msg.value.mul(_price).mul(10**18).div(1 ether);
        emit Print(tokenAmount);
        emit Print(msg.value);
        emit Print(uint(_price));
        _balances[msg.sender] = _balances[msg.sender].add(tokenAmount);
        totalRemainingTokensForSales = totalRemainingTokensForSales.sub(tokenAmount);
        moneyAll.add(msg.value);
    }

    function setPrivateSalePrice(uint _tokenPerEther) external onlyOwnerOrAdmin {
        require(_tokenPerEther > 0);

        privateSalePrice = _tokenPerEther;
    }

    function addToPrivateList(address privateClient) public onlyOwnerOrAdmin {
        require(privateClient != address(0));

        privateList[privateClient] = true;
    }

    function startPrivateSale() public onlyOwnerOrAdmin {
        require(privateSalePrice != 0);
        _state = PRIVATE_SALE;
    }

}
