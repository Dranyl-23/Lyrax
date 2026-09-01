#![cfg(test)]

use super::*;
use soroban_sdk::{
    testutils::{Address as _, Ledger},
    vec, Address, Env, String, Symbol,
};

fn create_token_contract<'a>(env: &Env, admin: &Address) -> token::Client<'a> {
    let token_address = env.register_stellar_asset_contract_v2(admin.clone());
    token::Client::new(env, &token_address.address())
}

#[test]
fn test_initialize_and_metadata() {
    let env = Env::default();
    env.mock_all_auths();

    let contract_id = env.register(LyraXCatalogVault, ());
    let client = LyraXCatalogVaultClient::new(&env, &contract_id);

    let admin = Address::generate(&env);
    let artist = Address::generate(&env);
    let investor_vault = Address::generate(&env);
    let producer = Address::generate(&env);
    let usdc = create_token_contract(&env, &admin);

    let splits = vec![
        &env,
        CollaboratorSplit {
            recipient: artist.clone(),
            bps: 6000, // 60%
            role: Symbol::new(&env, "ARTIST"),
        },
        CollaboratorSplit {
            recipient: investor_vault.clone(),
            bps: 3000, // 30%
            role: Symbol::new(&env, "VAULT"),
        },
        CollaboratorSplit {
            recipient: producer.clone(),
            bps: 1000, // 10%
            role: Symbol::new(&env, "PRODUCER"),
        },
    ];

    client.initialize(
        &admin,
        &usdc.address,
        &artist,
        &Symbol::new(&env, "LUNA01"),
        &148_500_0000000, // $148,500 valuation
        &14_800_0000000,  // $14,800 max advance
        &9420,            // 94.2% AI Underwrite Score
        &splits,
    );

    let metadata = client.get_metadata();
    assert_eq!(metadata.catalog_id, Symbol::new(&env, "LUNA01"));
    assert_eq!(metadata.artist, artist);
    assert_eq!(metadata.max_advance_usd, 14_800_0000000);
    assert_eq!(metadata.risk_score_bps, 9420);
    assert_eq!(metadata.is_funded, false);
    assert_eq!(metadata.advance_drawn, false);
}

#[test]
fn test_investment_and_advance_draw() {
    let env = Env::default();
    env.mock_all_auths();

    let contract_id = env.register(LyraXCatalogVault, ());
    let client = LyraXCatalogVaultClient::new(&env, &contract_id);

    let admin = Address::generate(&env);
    let artist = Address::generate(&env);
    let investor1 = Address::generate(&env);
    let usdc = create_token_contract(&env, &admin);

    let splits = vec![
        &env,
        CollaboratorSplit {
            recipient: artist.clone(),
            bps: 7000, // 70%
            role: Symbol::new(&env, "ARTIST"),
        },
        CollaboratorSplit {
            recipient: admin.clone(),
            bps: 3000, // 30%
            role: Symbol::new(&env, "VAULT"),
        },
    ];

    client.initialize(
        &admin,
        &usdc.address,
        &artist,
        &Symbol::new(&env, "LUNA01"),
        &100_000,
        &10_000, // $10,000 advance limit
        &9400,
        &splits,
    );

    // Mint USDC to investor
    let token_admin = token::StellarAssetClient::new(&env, &usdc.address);
    token_admin.mint(&investor1, &10_000);

    // Investor deposits into vault
    client.invest(&investor1, &10_000);
    assert_eq!(client.get_total_invested(), 10_000);
    assert_eq!(client.get_metadata().is_funded, true);

    // Artist draws advance
    client.draw_advance(&artist);
    assert_eq!(client.get_metadata().advance_drawn, true);
    assert_eq!(usdc.balance(&artist), 10_000);
}

#[test]
fn test_streaming_revenue_micro_distribution() {
    let env = Env::default();
    env.mock_all_auths();

    let contract_id = env.register(LyraXCatalogVault, ());
    let client = LyraXCatalogVaultClient::new(&env, &contract_id);

    let admin = Address::generate(&env);
    let artist = Address::generate(&env);
    let vault = Address::generate(&env);
    let producer = Address::generate(&env);
    let distributor = Address::generate(&env);
    let usdc = create_token_contract(&env, &admin);

    let splits = vec![
        &env,
        CollaboratorSplit {
            recipient: artist.clone(),
            bps: 6000, // 60%
            role: Symbol::new(&env, "ARTIST"),
        },
        CollaboratorSplit {
            recipient: vault.clone(),
            bps: 3000, // 30%
            role: Symbol::new(&env, "VAULT"),
        },
        CollaboratorSplit {
            recipient: producer.clone(),
            bps: 1000, // 10%
            role: Symbol::new(&env, "PRODUCER"),
        },
    ];

    client.initialize(
        &admin,
        &usdc.address,
        &artist,
        &Symbol::new(&env, "LUNA01"),
        &100_000,
        &10_000,
        &9400,
        &splits,
    );

    // Mint DSP streaming royalty deposit to distributor
    let token_admin = token::StellarAssetClient::new(&env, &usdc.address);
    token_admin.mint(&distributor, &1_000); // $1,000 royalty batch

    // Distribute streaming revenue via contract
    client.distribute_stream_revenue(&distributor, &1_000);

    // Verify splits: 60% to Artist ($600), 30% to Vault ($300), 10% to Producer ($100)
    assert_eq!(usdc.balance(&artist), 600);
    assert_eq!(usdc.balance(&vault), 300);
    assert_eq!(usdc.balance(&producer), 100);
    assert_eq!(client.get_total_disbursed(), 1_000);
}
