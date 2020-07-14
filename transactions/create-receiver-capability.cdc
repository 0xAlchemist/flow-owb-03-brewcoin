import BrewCoin from 0x01

// This transaction creates a capability
// that is linked to the account's token
// Vault. The capability is restricted to
// the fields in the 'Receiver' interface,
// so it can only be used to deposit funds
// into the account.

transaction {
    prepare(account: AuthAccount) {

        // Create a link to the Vault in account storage that is
        // restricated to fields and functions in the 'Receiver'
        // and 'Balance' interfaces, this only exposes the balance
        // field and deposit functions of the underlying Vault.
        //
        account.link<&BrewCoin.Vault{BrewCoin.Receiver, BrewCoin.Balance}>(/public/BrewCoinReceiver, target: /storage/BrewCoinVault)

        log("Public Receiver reference created")
    }

    post {
        // Check that the capabilities were created correctly
        // by getting the public capability and checking that
        // points to a valid Vault object that implements the
        // 'Receiver' interface.
        //
        getAccount(0x01).getCapability(/public/BrewCoinReceiver)!
                        .check<&BrewCoin.Vault{BrewCoin.Receiver}>():
                        "Vault Receiver reference was note created correctly"
    }
}