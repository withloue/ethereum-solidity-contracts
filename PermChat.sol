// contracts/PermChat.sol
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";

// @dev implementation of AccessControl into my ByteChat contract

contract PermChat is AccessControl {
  bytes public all = bytes("\n--start--\n");
  bytes private adm = bytes("\n--start--\n");
  bytes public last = bytes("\n--start--\n");
  bytes private lastAdmin = bytes("\n--start--\n");
  bytes32 public constant MUTED = keccak256("MRTED");
  constructor () {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
  }

  event newMessage(address u);
  event adminMessage(address u);
  event Appeal(address u);

  modifier onlyRole(bytes32 role){
    require(hasRole(role, msg.sender), "Insufficient role!");
    _;
  }
  modifier notRole(bytes32 role){
    require(!hasRole(role, msg.sender), "Insufficient role!");
    _;
  }


  function sendMessage(bytes calldata message) public notRole(MUTED) {
    last = bytes.concat("\n", toString(msg.sender), " -> ", message);
    all = bytes.concat(all, last);
    emit newMessage(msg.sender);
  }
  function admin(bytes calldata message) public onlyRole(DEFAULT_ADMIN_ROLE) {
    lastAdmin = bytes.concat("\n", toString(msg.sender), " -> ", message);
    adm = bytes.concat(all, last);
    emit adminMessage(msg.sender);
  }
  function appeal() public onlyRole(MUTED) {
    lastAdmin = bytes.concat("\n\n", toString(msg.sender), " Appeals for an unmute");
    adm = bytes.concat(adm, lastAdmin);
    emit Appeal(msg.sender); //clients can ignore if wishing to
  }
  function mute(address u) public onlyRole(DEFAULT_ADMIN_ROLE) {
    grantRole(MUTED, u);
  }
  function unmute(address u) public onlyRole(DEFAULT_ADMIN_ROLE) {
      grantRole(DEFAULT_ROLE, u);
  }

  function queryAdminLast() public view onlyRole(DEFAULT_ADMIN_ROLE) returns (bytes memory) {
    return lastAdmin;
  }
  function queryAdmin() public view onlyRole(DEFAULT_ADMIN_ROLE) returns (bytes memory) {
    return adm;
  }
  
  function grantAdmin(address grantee) public onlyRole(DEFAULT_ADMIN_ROLE) {
    grantRole(DEFAULT_ADMIN_ROLE, grantee);
  }
  function revoke(address revoked) public onlyRole(DEFAULT_ADMIN_ROLE) {
    revokeRole(DEFAULT_ADMIN_ROLE, revoked)
  }
  
  //utils
  
    function toString(address x) internal pure returns (bytes memory) { //either make this support uppercase, ideally find a more efficient way to convert address to string
    bytes memory s = new bytes(40);
    for (uint i = 0; i < 20; i++) {
        bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
        bytes1 hi = bytes1(uint8(b) / 16);
        bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
        s[2*i] = char(hi);
        s[2*i+1] = char(lo);            
    }
    return s;
  }

  function char(bytes1 b) pure internal returns (bytes1 c) {
    if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
    else return bytes1(uint8(b) + 0x57);
  }
    
}
