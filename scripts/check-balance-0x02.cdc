import FungibleToken from 0x01
import BrewCoin from 0x02

// This script reads the vault balance of account 2
pub fun main() {
    // Get the accounts' public account objects
    let acct = getAccount(0x02)

    // Get references to the accounts' receivers
    // by getting their public capability and
    // borrowing a reference from the capability
    //
    let acctReceiverRef = acct.getCapability(/public/BrewCoinBalance)!
                                .borrow<&BrewCoin.Vault{FungibleToken.Balance}>()!

    // Read and log the balance fields
    log("Account 2 Balance")
    log(acctReceiverRef.balance)
}