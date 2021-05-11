// contracts/compensation/DeployerCompensation.sol
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract DeployerCompensation {
  address payable deployer;
  uint compensation;
  constructor(uint8 multiplier) public payable {
    compensation = tx.gasprice*multiplier;
    deployer = payable(msg.sender);
  }
  modifier _compensate() public {
    if(compensation > 0){
      compensation - tx.gasprice/1000*2; //0.2%
      deployer.transfer(tx.gasprice/10000*2);
    }
    _;
  }
}
