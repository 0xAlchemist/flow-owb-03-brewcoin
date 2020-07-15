
/**

This transaction is used to set up an account to 
forward deposited tokens to another receiver.

If anyone sends tokens to a user's Forwarder Receiver,
the Receiver will just forward those tokens to the Vault that has been
set as the recipient and emit an event that indicates
which user forwarded the tokens.

This way, if an off-chain service wants to monitor who is forwarding
tokens to it, it can watch events to see where the tokens came from.

Steps to set up accounts with token forwarder:

1. The Fungible Token contract interface should already be deployed somewhere
2. The applicable token contract should be deployed.
3. The recipient account should have a Vault for this token created
    and stored in its storage with a published Receiver
4. Deploy the `TokenForwarding.cdc` contract to a different account
5. For a new Account: Create the account normally,
    then run the `create_forwarder.cdc` transaction,
    getting the Receiver from the account that is the recipient.
*/

import FungibleToken from 0xee82856bf20e2aa6
import BrewCoin from 0x01cf0e2f2f715450
import TokenForwarding from 0x179b6b1cb6755e31

transaction() {

    prepare(acct: AuthAccount) {
        let recipient = getAccount(0xf3fcd2c1a78f5eee).getCapability<&{FungibleToken.Receiver}>(/public/BrewCoinReceiver)!

        let vault <- TokenForwarding.createNewForwarder(recipient: recipient)

        acct.save(<-vault, to: /storage/BrewCoinForwarder)

        if acct.getCapability(/public/BrewCoinReceiver)!.borrow<&{FungibleToken.Receiver}>() != nil {
            acct.unlink(/public/BrewCoinReceiver)
        }
        acct.link<&{FungibleToken.Receiver}>(/public/BrewCoinReceiver, target: /storage/BrewCoinForwarder)
    }
}