import BrewCoin from 0x01

// This transaction mints tokens and deposits them into Account 2's Vault
transaction {

    // Local variable for storing the reference to the minter resource
    let mintingRef: &BrewCoin.VaultMinter

    // Local variable for storing the reference to the Vault of
    // the account that will receive the newly minted tokens
    var receiverRef: &BrewCoin.Vault{BrewCoin.Receiver}

    prepare(account: AuthAccount) {
        // Borrow a reference to the stored, private minter resource
        self.mintingRef = account.borrow<&BrewCoin.VaultMinter>(from: /storage/BrewCoinMinter)!

        // Get the public account object for account 0x02
        let recipient = getAccount(0x02)

        // Get the public receiver capability
        let capability = account.getCapability(/public/BrewCoinReceiver)!
                            
        // Borrow a reference from the capability
        self.receiverRef = capability.borrow<&BrewCoin.Vault{BrewCoin.Receiver}>()!
    }

    execute {
        // Mint 30 tokens and deposit them into the recipient's Vault
        self.mintingRef.mintTokens(amount: UFix64(30), recipient: self.receiverRef)

        log("30 tokens minted and deposited to Account 0x02")
    }
}