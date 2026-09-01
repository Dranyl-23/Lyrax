#![cfg(test)]

use super::*;
use soroban_sdk::{
    testutils::Address as _,
    Address, Env, String,
};

#[test]
fn test_royalty_token_lifecycle() {
    let env = Env::default();
    env.mock_all_auths();

    let contract_id = env.register(LyraXRoyaltyToken, ());
    let client = LyraXRoyaltyTokenClient::new(&env, &contract_id);

    let admin = Address::generate(&env);
    let investor_alice = Address::generate(&env);
    let investor_bob = Address::generate(&env);

    client.initialize(
        &admin,
        &7,
        &String::from_str(&env, "Luna Ray Catalog Share"),
        &String::from_str(&env, "LUNA-SHARE"),
    );

    assert_eq!(client.decimals(), 7);
    assert_eq!(client.name(), String::from_str(&env, "Luna Ray Catalog Share"));
    assert_eq!(client.symbol(), String::from_str(&env, "LUNA-SHARE"));
    assert_eq!(client.total_supply(), 0);

    // Mint 2,500 shares to Alice
    client.mint(&investor_alice, &2_500);
    assert_eq!(client.balance(&investor_alice), 2_500);
    assert_eq!(client.total_supply(), 2_500);

    // Alice transfers 500 shares to Bob
    client.transfer(&investor_alice, &investor_bob, &500);
    assert_eq!(client.balance(&investor_alice), 2_000);
    assert_eq!(client.balance(&investor_bob), 500);
    assert_eq!(client.total_supply(), 2_500);
}
