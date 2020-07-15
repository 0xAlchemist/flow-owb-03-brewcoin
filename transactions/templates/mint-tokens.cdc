// This transaction is a template for a transaction that
// could be used by the BrewCoin admin account to mint tokens
//
// The recipient address and amount would
// be the parameters for the transaction

import FungibleToken from 0xee82856bf20e2aa6
import BrewCoin from 0x01cf0e2f2f715450

transaction(recipient: Address, amount: UFix64) {
    let tokenAdmin: &BrewCoin.Administrator
    let tokenReceiver: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.tokenAdmin = signer
        .borrow<&BrewCoin.Administrator>(from: /storage/BrewCoinAdmin)
        ?? panic("Signer is not the token admin. Naughty signer!")

        self.tokenReceiver = getAccount(recipient)
        .getCapability(/public/BrewCoinReceiver)!
        .borrow<&{FungibleToken.Receiver}>()
        ?? panic("Could not borrow receiver reference")
    }

    execute {
        let minter <- self.tokenAdmin.createNewMinter(allowedAmount: 100.0)
        let mintedVault <- minter.mintTokens(amount: amount)

        self.tokenReceiver.deposit(from: <-mintedVault)

        destroy minter
    }
}