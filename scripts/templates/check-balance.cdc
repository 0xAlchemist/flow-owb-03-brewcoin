// This script is a template that reads the balance
// field of an account's BrewCoin Vault

import FungibleToken from 0xee82856bf20e2aa6
import BrewCoin from 0x01cf0e2f2f715450

pub fun main(address: Address): UFix64 {
    
    let acct = getAccount(address)
    let vaultRef = acct.getCapability(/public/BrewCoinBalance)!.borrow<&BrewCoin.Vault{FungibleToken.Balance}>() 
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}