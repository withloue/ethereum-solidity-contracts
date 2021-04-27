# eth-solidity-contracts
A repository to store my loose projects related to the ethereum blockchain, built in solidity
# ByteChat.sol
While playing with strings and bytes I came up with this simple contract that uses the new bytes.concat method from Solidity 0.8.4


A method to send a message (in bytes form)
A variable to call to get access to the chat history (in bytes form)
A variable to call to get access to the last message (in bytes form)
An event that is emitted when someone sends a message 
# PermChat.sol
Reading up on token standards I came across openzeppelin contracts and learnt of AccessControl, implemented my ByteChat contract to add some admin permissions


Admin Only -
A method to send an admin only message (in bytes form)
A method to retreive the last admin only message (in bytes form)
A method to retreive the admin only chat history (in bytes form)
A method to mute addresses from speaking
A method to unmute addresses from speaking

Muted Only -
A method to appeal a mute

Muted Restricted -
A method to send a message (in bytes form)
A variable to call to get access to the chat history (in bytes form)
A variable to call to get access to the last message (in bytes form)

Events -
Appeal: called when someone appeals
adminMessage: called when an admin sends an admin only message
newMessage: called when a new message comes in the public chat

