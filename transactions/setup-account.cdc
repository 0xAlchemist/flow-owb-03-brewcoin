import FungibleToken from 0xee82856bf20e2aa6
import BrewCoin from 0x01cf0e2f2f715450
//
// Sender: 0x02

// This transaction configures an account to store and receive tokens
// defined by the BrewCoin contract
//
transaction {
    prepare(signer: AuthAccount) {
        
        // Make sure the signer doesn't already have a BrewCoin Vault
        if signer.borrow<&BrewCoin.Vault>(from: /storage/BrewCoinVault) == nil {
            // Create a new BrewCoin Vault and save it in storage
            signer.save(<-BrewCoin.createEmptyVault(), to: /storage/BrewCoinVault)

            // Create the public capability to the Vault that only
            // exposes the Receiver interface
            signer.link<&BrewCoin.Vault{FungibleToken.Receiver}>(
                /public/BrewCoinReceiver,
                target: /storage/BrewCoinVault
            )

            // Create the public capability to the Vault that only
            // exposes the Balance interface
            signer.link<&BrewCoin.Vault{FungibleToken.Balance}>(
                /public/BrewCoinBalance,
                target: /storage/BrewCoinVault
            )
        }
    }
}
