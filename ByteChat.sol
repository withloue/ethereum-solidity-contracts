// contracts/chat.sol
// SPDX-License-Identifier: GPL-3.0


// @dev an implementation of the new bytes.concat feature to make a simple chat application

pragma solidity ^0.8.4;

contract ByteChat {
  bytes public all = bytes("\n--start--\n");
  bytes public last = bytes("\n--start--\n");

  event newMessage(address u);
  
  function sendMessage(bytes calldata message) public {
    last = bytes.concat("\n", toString(msg.sender), " -> ", message);
    all = bytes.concat(all, last);
    emit newMessage(msg.sender);
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
