// This transaction is a template for a transaction that
// could be used by the admin account to burn tokens
// from their stored Vault
//
// The burning amount would be the only parameter for the transaction

import FungibleToken from 0xee82856bf20e2aa6
import BrewCoin from 0x01cf0e2f2f715450

transaction(amount: UFix64) {
    
    // Vault resource that holds the tokens that are being burned
    let vault: @FungibleToken.Vault

    let admin: &BrewCoin.Administrator

    prepare(signer: AuthAccount) {

        // Withdraw 10 tokens from the admin account in storage
        self.vault <- signer.borrow<&BrewCoin.Vault>(from: /storage/BrewCoinVault)!
                        .withdraw(amount: amount)

        // Create a reference to the admin resource in storage
        self.admin = signer.borrow<&BrewCoin.Administrator>(from: /storage/BrewCoinAdmin)
                        ?? panic("Could not borrow a reference to the admin resource")
    }

    execute {
        let burner <- self.admin.createNewBurner()

        burner.burnTokens(from: <-self.vault)

        destroy burner
    }
}