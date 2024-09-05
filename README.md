# Move Contract: `tx::app`

The Move contract `tx::app` provides a simple on-chain messaging service where users can sign and store messages. Each message is stored on the blockchain and associated with a timestamp and the sender's address. Here's a breakdown of the contract's key components:

---

### Constants and Structures:

- **`MODULE_ADMIN`**:
  - The address `@tx` is designated as the admin of the module. Only this admin can initialize the contract.

- **`EINVALID_ADMIN_ADDR`**:
  - An error code (`1`) representing an invalid admin address, used to ensure only the correct admin can initialize the contract.

- **`Txs (struct)`**:
  - A data structure that stores a vector of signed messages (`messages: vector<String>`).

- **`NewTx (event)`**:
  - An event structure with three fields:
    - `timestamp: u64`: The time the message was signed.
    - `user: address`: The address of the user who signed the message.
    - `message: String`: The content of the signed message.
  - The event is emitted every time a new message is signed.

---

### Entry Functions:

#### 1. **`init(admin: &signer)`**
   - Initializes the contract and can only be called by the admin (designated by `@tx`).
   - Validates that the caller is the admin by checking if the caller's address matches `MODULE_ADMIN`.
   - If valid, it creates a `Txs` struct with an empty list of messages and moves it under the admin's account.
   - **Error Handling**: If the caller's address is not `@tx`, it aborts with the error `EINVALID_ADMIN_ADDR`.

#### 2. **`sign_message(user: &signer, message: String)`**
   - Allows any user to sign a message and store it in the `Txs` struct.
   - The function:
     1. Adds the message to the `messages` vector in the `Txs` struct.
     2. Emits a `NewTx` event with the message, the sender's address, and the timestamp.
   - This event helps track when and by whom messages are signed on the blockchain.

#### 3. **`read_messages()`**
   - A view-only function that retrieves all stored messages.
   - Returns the list of messages stored in the `Txs` struct.
   - This function does not modify the blockchain's state, making it safe for read-only operations.

---

### Interact with the contract

All the parameters and dependendecies are defined in `Move.toml`

1. Initial Setup**
Initialize your Aptos CLI wallet and configure your environment.

```bash
aptos init
```
2. Check Account Information
```bash
aptos account list
aptos account balance
```

3. Compile Move Code
```bash
aptos move compile
```

4. Compile with Named Addresses
```bash
aptos move compile --named-addresses tx=<your_address>
```

5. Publish Your Contract On-Chain
```bash
aptos move publish --named-addresses tx=<your_address>
```

6. Initialize the Contract
```bash
aptos move run --function-id <module_address>::tx::app::init --profile default
```

7. Sign a Message
```bash
aptos move run --function-id <module_address>::tx::app::sign_message --profile default --args  <message>
```