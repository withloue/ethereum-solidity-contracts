# eth-solidity-contracts
A repository to store my loose projects related to the ethereum blockchain, built in solidity
### ByteChat/ByteChat.sol
While playing with strings and bytes I came up with this simple contract that uses the new bytes.concat method from Solidity 0.8.4

- A method to send a message (in bytes form) 
- A variable to call to get access to the chat history (in bytes form) 
- A variable to call to get access to the last message (in bytes form) 
- An event that is emitted when someone sends a message 
## ByteChat/ByteChatDM.sol
An implementation of direct messaging using the concept of ByteChat, though this time i decided to not use bytes.concat in implementation

- A function to retrieve the channel ID associated with sender and specified address
- A function to send messages to a specified address
- A function to retrieve the last 32 messages in a channel
- A function to retrieve the last message in a channel
- An event that is emitted when someone sends a message to someone else, containing the recipient and the message <br />
  
_Because the message is publicly available it is recommended to use end to end encryption before interacting with this contract_  

### compensation/DeployerCompensation.sol
A simple contract of compensating the deployer 0.2% on specified functions that have the modifier `_compensate()`, stops compensating when a certain amount is reached (deployment cost * multiplier specified in constructor)

### PermChat.sol
Reading up on token standards I came across openzeppelin contracts and learnt of AccessControl, implemented my ByteChat contract to add some admin permissions


Admin Only -
- A method to send an admin only message (in bytes form)
- A method to retreive the last admin only message (in bytes form)
- A method to retreive the admin only chat history (in bytes form)
- A method to mute addresses from speaking
- A method to unmute addresses from speaking

Muted Only -
- A method to appeal a mute

Muted Restricted -
- A method to send a message (in bytes form)
- A variable to call to get access to the chat history (in bytes form)
- A variable to call to get access to the last message (in bytes form)

Events -
- Appeal: called when someone appeals
- adminMessage: called when an admin sends an admin only message
- newMessage: called when a new message comes in the public chat

