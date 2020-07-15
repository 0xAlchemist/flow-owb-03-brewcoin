// This script reads the balance field of an account's BrewCoin Vault

import FungibleToken from 0xee82856bf20e2aa6
import BrewCoin from 0x01cf0e2f2f715450

pub fun main() {
    // Create an array of addresses
    var accounts: [Address] = [
            Address(0x01cf0e2f2f715450), 
            Address(0x179b6b1cb6755e31)
        ]

    // Loop through each address and log the balance
    for acct in accounts {
        let acct = getAccount(acct)
        let vaultRef = acct.getCapability(/public/BrewCoinBalance)!.borrow<&BrewCoin.Vault{FungibleToken.Balance}>() ?? panic("Could not borrow Balance reference to the Vault")
            
        log(acct)
        log(vaultRef.balance)
    }
}