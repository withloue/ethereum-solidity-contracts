// contracts/ByteChat/ByteChatDM.sol
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "../compensation/DeployerCompensation.sol";
contract ByteChatDM is DeployerCompensation(2) {
  //implement: whitelist/blaclist (blocking), uid, display names and other address metadata?,
  private mapping(bytes32 => bytes[32]) DMs; //last 32 messages in users' DMs, uid
  event message(address, bytes calldata); //preferrably use end to end encryption before inputting messages in this contract
  function channel(address other) external virtual returns (bytes32) { //get channel uri
    return uid(msg.sender, other);
  }
  function uid(address one, address two) internal pure returns (bytes32) {
    //unique to msg.sender <-> to
    if(uint160(one) > uint160(two))
      return keccak256(abi.encodePacked(one, two));
    return keccak256(abi.encodePacked(two, one));
  }
  function sendMessage(address to, bytes calldata _message) public virtual _compensate() {
    require(to != address(0), "Zero Address not messagable.");
    bytes32 id = uid(msg.sender, to);
    message = bytes.concat(abi.encodePacked(msg.sender), message);
    for(uint i = 30; i >= 0; i--)
      DMs[id][i+1] = DMs[id][i]; //move all messages up one
    DMs[id][0] = _message; //add the new message
    emit message(to, _message);
  }
  function messages(bytes32 _channel) external virtual _compensate() returns (bytes[] memory){
    return DMs[_channel];
  }
  function lastMessage(bytes32 _channel) external virtual _compensate() returns (bytes memory){
    return DMs[_channel][0];
  }
}
