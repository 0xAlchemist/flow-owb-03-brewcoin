import BrewCoin from 0x01

// This transaction transfers tokens between accounts
transaction {
    // Temporary Vault object holds the balance that is being transferred
    var temporaryVault: @BrewCoin.Vault

    prepare(account: AuthAccount) {
        // Withdraw tokens from your Vault by borrowing a reference to it
        // and calling the withdraw function with that reference
        let vaultRef = account.borrow<&BrewCoin.Vault>(from: /storage/BrewCoinVault)!

        self.temporaryVault <- vaultRef.withdraw(amount: UFix64(5))
    }

    execute {
        // Get the recipient's public account object
        let recipient = getAccount(0x02)

        // Get the recipient's Receiver reference to their Vault
        // by borrowing the reference from the public capability
        let receiverRef = recipient.getCapability(/public/BrewCoinReceiver)!
                                   .borrow<&BrewCoin.Vault{BrewCoin.Receiver}>()!

        // Deposit your coins into their Vault
        receiverRef.deposit(from: <-self.temporaryVault)

        log("Transfer succeeded")
    }
}