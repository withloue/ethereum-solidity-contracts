// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 < 0.9.0;

/**
 * @title Example
 * @dev helped me understand, gas price seems tremendous though
 */
 contract Example {
     enum Currency { Dollar, Denar, Rupee, Yen } //types of money, enum declaration
     struct Cash { //money stored along with its type
         uint denomination;
         Currency currency;
     }
     struct Wallet {
         Cash[] cash;
         mapping(Currency => uint) amounts; //due to having this, all Wallet types are now restricted to storage access only
         address nominee; //who's wallet to credit on clear
     }
     address private initializer;
     mapping(address => Wallet) wallets;
     modifier isInitializer(){
         require(msg.sender == initializer, "Not initializer.");
         _;
     }
     modifier hasBalance(){
         require(wallets[msg.sender].cash.length != 0, "Wallet empty.");
         _;
     }
     modifier hasNominee(){
         require(wallets[msg.sender].nominee != address(0));
         _;
     }
     constructor() {
         initializer = msg.sender;
     }
     function newDenomination(Cash memory cash, address benefactor) public isInitializer {
         wallets[benefactor].cash.push(cash);
         wallets[benefactor].amounts[cash.currency] += cash.denomination;
     }
     function newDenomination(Cash memory cash) public isInitializer {
         newDenomination(cash, initializer);
     }
     function newDenominations(Cash[] memory cash, address benefactor) public isInitializer {
         for(uint i = 0; i < cash.length; i++){
             newDenomination(cash[i], benefactor);
         }
     }
     function newDenominations(Cash[] memory cash) public isInitializer {
         newDenominations(cash, initializer);
     }
     function constructCash(uint denomination_, Currency currency_) public view isInitializer returns (Cash memory cash) {
         cash = Cash({denomination: denomination_,
                      currency: currency_});
     }
     function viewBalance() public view returns(Cash[] memory cash){
         address read = msg.sender;
         cash = wallets[read].cash;
     }
     function transfer(address to, Cash memory cash_) private {
         wallets[to].cash.push(cash_);
         wallets[to].amounts[cash_.currency] += cash_.denomination;
     }
     
     function remove(uint index, address wallet)  private {
        if (index >= wallets[wallet].cash.length) return;

        wallets[wallet].cash[index] = wallets[wallet].cash[wallets[wallet].cash.length-1];
        wallets[wallet].cash.pop;
     }
     function transfer(address to_, uint amount, Currency currency_) public hasBalance {
         require(wallets[msg.sender].amounts[currency_] >= amount, "Not enough funds in the specified currency!");
         uint b = wallets[msg.sender].cash.length;
         uint totalTransferred;
         for(uint i = 0; i < b; b--){
             if(totalTransferred >= amount){
                 b = 0;
             }
             if(wallets[msg.sender].cash[i].currency == currency_){
                 if((totalTransferred + wallets[msg.sender].cash[b].denomination) > amount){
                     //greater than expected, perhaps a message atleast? but ideally a method to get the closest to 0 overexchange
                 }
                 transfer(to_, wallets[msg.sender].cash[b]);
                 totalTransferred += wallets[msg.sender].cash[b].denomination;
                 remove(b, msg.sender);
                 
             }
         }
         
     }
     function clear() public hasBalance hasNominee {
         for(uint i = 0; i < wallets[msg.sender].cash.length; i++){
             transfer(wallets[msg.sender].nominee, wallets[msg.sender].cash[i]);
             remove(i, msg.sender);
         }
     }
     function nominee(address nominee_) public {
         wallets[msg.sender].nominee = nominee_;
     }
 }
