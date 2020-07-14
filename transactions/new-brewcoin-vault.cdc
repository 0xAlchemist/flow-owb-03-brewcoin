import BrewCoin from 0x01

// Run this transaction from account 0x02

// This transaction configures an account to store and receive tokens
// defined by the BrewCoin contract
//
transaction {
    prepare(account: AuthAccount) {
        // Create a new empty Vault
        let newVault <- BrewCoin.createEmptyVault()

        // Store the Vault in account storage
        account.save<@BrewCoin.Vault>(<-newVault, to: /storage/BrewCoinVault)

        log("Empty Vault created and stored")

        // Create a public Receiver capabilty for the Vault
        let receiverRef = account.link<&BrewCoin.Vault{BrewCoin.Receiver, BrewCoin.Balance}>(/public/BrewCoinReceiver, /storage/BrewCoinVault)

        log("References created")
    }

    post {
        // Check that the capabilities were created correctly
        getAccount(0x02).getCapability(/public/BrewCoinReceiver)!
                        .check<&BrewCoin.Vault{BrewCoin.Receiver}>():
                        "Vault Receiver References were not created correctly"

    }
}