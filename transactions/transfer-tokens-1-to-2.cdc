// This transaction is a template for a transaction that
// could be used by anyone to send tokens to another account
// that has been set up to receive tokens.
//
// The withdraw amount and the account from getAccount
// would be the parameters to the transaction

import FungibleToken from 0xee82856bf20e2aa6
import BrewCoin from 0x01cf0e2f2f715450

transaction() {

    // The Vault resource that holds the tokens that are being transferred
    let sentVault: @FungibleToken.Vault
    let amount: UFix64
    let recipient: Address

    prepare(signer: AuthAccount) {
        
        self.amount = 50.0 // Change to UFix64 value to test
        self.recipient = 0x179b6b1cb6755e31 // Account 2

        // Get a reference to the signer's stored Vault
        let vaultRef = signer.borrow<&BrewCoin.Vault>(from: /storage/BrewCoinVault)
                        ?? panic("Could not borrow reference to the owner's Vault!")
        
        // Withdraw tokens from the signer's stored Vault
        self.sentVault <- vaultRef.withdraw(amount: self.amount)
    }

    execute {
        // Get the recipient's public account object
        let recipient = getAccount(self.recipient)

        // Get a reference to the recipient's Receiver
        let receiverRef = recipient.getCapability(/public/BrewCoinReceiver)!.borrow<&{FungibleToken.Receiver}>()
            ?? panic("Could not borrow receiver reference to the recipient's Vault")

        // Deposit the withdrawn tokens into the recipient's Vault
        receiverRef.deposit(from: <- self.sentVault)
    }
}
