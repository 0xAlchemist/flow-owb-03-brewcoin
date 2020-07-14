import FungibleToken from 0x01
import BrewCoin from 0x02
//
// Sender: 0x01

// This transaction configures an account to store and receive tokens
// defined by the BrewCoin contract
//
transaction {
    prepare(account: AuthAccount) {

        let newVault <- BrewCoin.createEmptyVault()

        account.save<@BrewCoin.Vault>(<-newVault, to: /storage/BrewCoinVault)

        log("Empty Vault created and stored")


        let receiverRef = account.link<&BrewCoin.Vault{FungibleToken.Receiver}>(
            /public/BrewCoinReceiver,
            target: /storage/BrewCoinVault
        )

        let balanceRef = account.link<&BrewCoin.Vault{FungibleToken.Balance}>(
            /public/BrewCoinBalance,
            target: /storage/BrewCoinVault
        )
        
        log("References created")
    }

    post {
        // Check that the capabilities were created correctly
        getAccount(0x01).getCapability(/public/BrewCoinReceiver)!
                        .check<&BrewCoin.Vault{FungibleToken.Receiver}>():
                        "Vault Receiver References were not created correctly"

        getAccount(0x01).getCapability(/public/BrewCoinBalance)!
                        .check<&BrewCoin.Vault{FungibleToken.Balance}>():
                        "Vault Balance References were not created correctly"

    }
}