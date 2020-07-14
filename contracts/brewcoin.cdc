// BrewCoin is a fungible token used for testing
// marketplace purchases

// Flow Playground URL: https://play.onflow.org/b8fa9d7e-c6e0-4fca-9e5f-ed806ebd0106

// Import the Flow FungibleToken interface
import FungibleToken from 0xee82856bf20e2aa6

pub contract BrewCoin {

    // Total supply of all BrewCoins in circulation.
    pub var totalSupply: UFix64

    // Provider
    //
    // Interface that forces the requirements for withdrawing
    // tokens from the implementing type.
    //
    pub resource interface Provider {

        // withdraw
        //
        // Function that subtracts tokens from the owner's Vault
        // and returns a Vault resource (@Vault) with the removed tokens.
        //
        pub fun withdraw(amount: UFix64): @Vault {
            post {
                // 'result' refers to the return value of the function
                result.balance == UFix64(amount):
                    "Withdrawal amount must be the same as the balance of the withdrawn Vault"
            }
        }
    }

    // Receiver
    //
    // Interface that enforces the requirements for depositing
    // tokens into the implementing type
    //
    pub resource interface Receiver {
        // deposit
        //
        // Function that can be called to deposit tokens
        // into the implementing resource type
        //
        pub fun deposit(from: @Vault) {
            pre {
                from.balance > UFix64(0):
                    "Deposit balance must be positive"
            }
        }
    }

    // Balance
    //
    // Interface that specifies a public 'balance' field for the Vault
    //
    pub resource interface Balance {
        pub var balance: UFix64
    }

    // Vault
    //
    // Each user stores an instance of only the Vault in their storage
    // The functions in the Vault and governed by the pre and post conditions
    // in the interfaces when they are called. 
    // The checks happen at runtime whenever a function is called.
    pub resource Vault: Provider, Receiver, Balance {

        // Keeps track of the total account balance for this Vault
        pub var balance: UFix64

        // Initialize the balance at resource creation time
        init(balance: UFix64) {
            self.balance = balance
        }

        // withdraw
        //
        // Function that takes an integer amount as an argument
        // and withdraws that amount of tokens from the Vault.
        //
        // It creates a new temporary Vault that contains the
        // withdrawn tokens and returns the temporary Vault to 
        // the calling context to be deposited elsewhere
        //
        pub fun withdraw(amount: UFix64): @Vault {
            self.balance = self.balance - amount
            return <-create Vault(balance: UFix64(amount))
        }

        // deposit
        //
        // Function that takes a Vault object as an argument
        // and adds its balance to the balance of the owner's
        // Vault.
        //
        // It destroys the temporary Vault after the tokens
        // have been deposited.
        //
        pub fun deposit(from: @Vault) {
            self.balance = self.balance + from.balance
            destroy from
        }
    }

    // createEmptyVault
    //
    // Function that creates a new Vault with a balance of zero
    // and returns it to the calling context. A user must call
    // this function and store the returned Vault in their storage
    // to enable deposits of this token type.
    //
    pub fun createEmptyVault(): @Vault {
        return <-create Vault(balance: UFix64(0))
    }

    // VaultMinter
    //
    // Resource object that an admin can control to mint new tokens
    pub resource VaultMinter {

        // mintTokens
        //
        // Function that mints new tokens and deposits into an
        // account's Vault using their 'Receiver' reference.
        // We say '&AnyResource{Receiver}' to say that the
        // recipient can be any resource as long as it
        // implements the Receiver interface
        //
        pub fun mintTokens(amount: UFix64, recipient: &AnyResource{Receiver}) {
            // Increase totalSupply count by 'amount'
            BrewCoin.totalSupply = BrewCoin.totalSupply + UFix64(amount)
            // Deposit the tokens in the recipient's Vault
            recipient.deposit(from: <-create Vault(balance: UFix64(amount)))
        }
    }

    // The init function initializes the fields for the BrewCoin contract.
    init() {
        self.totalSupply = UFix64(1000)

        // Create the Vault with the initial balance and put it in storage
        // account.save saves an object to the specified 'to' path.
        // The path is a literal path that consist of a domain and identifier.
        // The domain must be 'storage', 'public' or 'private'.
        // The identifier can be any name.
        //
        self.account.save(<-create Vault(balance: UFix64(1000)), to: /storage/BrewCoinVault)

        // Create a new VaultMinter resource and store it in account storage
        self.account.save(<-create VaultMinter(), to: /storage/BrewCoinMinter)
    }
}