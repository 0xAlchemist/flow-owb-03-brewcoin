import FungibleToken from 0x01
import BrewCoin from 0x02

// This script reads the vault balances of two accounts
pub fun main() {
    // Get the accounts' public account objects
    let acct1 = getAccount(0x01)
    let acct2 = getAccount(0x02)

    // Get references to the accounts' receivers
    // by getting their public capability and
    // borrowing a reference from the capability
    //
    let acct1ReceiverRef = acct1.getCapability(/public/BrewCoinReceiver)!
                                .borrow<&BrewCoin.Vault{FungibleToken.Balance}>()!

    let acct2ReceiverRef = acct2.getCapability(/public/BrewCoinReceiver)!
                                .borrow<&BrewCoin.Vault{FungibleToken.Balance}>()!

    // Read and log the balance fields
    log("Account 1 Balance")
    log(acct1ReceiverRef.balance)
    log(" ")
    log("Account 2 Balance")
    log(acct2ReceiverRef.balance)
}