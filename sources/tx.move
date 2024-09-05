module tx::app{

    use aptos_framework::event;
    use std::string::{String};
    use std::vector;
    use std::signer;
    use std::timestamp;

    const MODULE_ADMIN: address = @tx;

    const EINVALID_ADMIN_ADDR: u64 = 1;

    struct Txs has key {
        messages: vector<String>
    }

    #[event]
    struct NewTx has store, drop {
        timestamp: u64,
        user: address,
        message: String
    }

    public entry fun init(admin: &signer){
        assert!( signer::address_of(admin) == MODULE_ADMIN, EINVALID_ADMIN_ADDR);
        move_to(admin, Txs{
            messages: vector::empty<String>()
        })
    }

    public entry fun sign_message(user: &signer, message: String) acquires Txs{
        let txs = borrow_global_mut<Txs>(MODULE_ADMIN);
        vector::push_back<String>(&mut txs.messages, copy message);
        event::emit<NewTx>(NewTx {
            timestamp: timestamp::now_seconds(),
            user: signer::address_of(user),
            message: message
        });
    }

    #[view]
    public fun read_messages(): vector<String> acquires Txs{
        let txs = borrow_global<Txs>(MODULE_ADMIN);
        let messages = txs.messages; 
        return messages
    }
}