#![no_std]
use soroban_sdk::{
    contract, contracterror, contractimpl, contracttype, token, Address, Env, IntoVal, Symbol,
    TryFromVal, Val, Vec,
};

#[contracterror]
#[derive(Copy, Clone, Debug, Eq, PartialEq, PartialOrd, Ord)]
#[repr(u32)]
pub enum VaultError {
    AlreadyInitialized = 1,
    NotInitialized = 2,
    InvalidSplitTotal = 3,
    AdvanceAlreadyDrawn = 4,
    InsufficientPoolFunding = 5,
    InvalidAmount = 6,
    Unauthorized = 7,
}

#[contracttype]
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct CollaboratorSplit {
    pub recipient: Address,
    pub bps: u32, // Basis points: 100 bps = 1%, 10,000 bps = 100%
    pub role: Symbol,
}

#[contracttype]
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct CatalogMetadata {
    pub catalog_id: Symbol,
    pub artist: Address,
    pub total_valuation_usd: i128,
    pub max_advance_usd: i128,
    pub risk_score_bps: u32, // e.g. 9420 = 94.2%
    pub is_funded: bool,
    pub advance_drawn: bool,
}

#[contracttype]
pub enum DataKey {
    Admin,
    UsdcToken,
    Metadata,
    Splits,
    TotalInvested,
    TotalRevenueDisbursed,
    InvestorShare(Address),
}

#[contract]
pub struct LyraXCatalogVault;

#[contractimpl]
impl LyraXCatalogVault {
    /// Initializes a tokenized catalog pool on Stellar Soroban with AI Underwriting parameters
    pub fn initialize(
        env: Env,
        admin: Address,
        usdc_token: Address,
        artist: Address,
        catalog_id: Symbol,
        total_valuation_usd: i128,
        max_advance_usd: i128,
        risk_score_bps: u32,
        splits: Vec<CollaboratorSplit>,
    ) -> Result<(), VaultError> {
        if env.storage().instance().has(&DataKey::Metadata) {
            return Err(VaultError::AlreadyInitialized);
        }

        admin.require_auth();

        // Validate splits sum to exactly 10,000 basis points (100%)
        let mut total_bps: u32 = 0;
        for split in splits.iter() {
            total_bps = total_bps.checked_add(split.bps).ok_or(VaultError::InvalidSplitTotal)?;
        }
        if total_bps != 10_000 {
            return Err(VaultError::InvalidSplitTotal);
        }

        let metadata = CatalogMetadata {
            catalog_id,
            artist,
            total_valuation_usd,
            max_advance_usd,
            risk_score_bps,
            is_funded: false,
            advance_drawn: false,
        };

        env.storage().instance().set(&DataKey::Admin, &admin);
        env.storage().instance().set(&DataKey::UsdcToken, &usdc_token);
        env.storage().instance().set(&DataKey::Metadata, &metadata);
        env.storage().instance().set(&DataKey::Splits, &splits);
        env.storage().instance().set(&DataKey::TotalInvested, &0i128);
        env.storage().instance().set(&DataKey::TotalRevenueDisbursed, &0i128);

        Ok(())
    }

    /// Investors deposit USDC to buy fractional royalty shares and fund the artist's advance
    pub fn invest(env: Env, investor: Address, amount: i128) -> Result<(), VaultError> {
        investor.require_auth();

        if amount <= 0 {
            return Err(VaultError::InvalidAmount);
        }

        let usdc_token: Address = env.storage().instance().get(&DataKey::UsdcToken).ok_or(VaultError::NotInitialized)?;
        let mut metadata: CatalogMetadata = env.storage().instance().get(&DataKey::Metadata).ok_or(VaultError::NotInitialized)?;
        let mut total_invested: i128 = env.storage().instance().get(&DataKey::TotalInvested).unwrap_or(0i128);

        // Transfer USDC from investor into this contract vault
        let client = token::Client::new(&env, &usdc_token);
        client.transfer(&investor, &env.current_contract_address(), &amount);

        // Record investment
        total_invested = total_invested.checked_add(amount).ok_or(VaultError::InvalidAmount)?;
        env.storage().instance().set(&DataKey::TotalInvested, &total_invested);

        let current_share: i128 = env.storage().instance().get(&DataKey::InvestorShare(investor.clone())).unwrap_or(0i128);
        env.storage().instance().set(&DataKey::InvestorShare(investor), &(current_share + amount));

        // Check if advance is fully funded
        if total_invested >= metadata.max_advance_usd && !metadata.is_funded {
            metadata.is_funded = true;
            env.storage().instance().set(&DataKey::Metadata, &metadata);
        }

        Ok(())
    }

    /// Artist draws their instant USDC cash advance once funded
    pub fn draw_advance(env: Env, artist: Address) -> Result<(), VaultError> {
        artist.require_auth();

        let mut metadata: CatalogMetadata = env.storage().instance().get(&DataKey::Metadata).ok_or(VaultError::NotInitialized)?;

        if metadata.artist != artist {
            return Err(VaultError::Unauthorized);
        }
        if metadata.advance_drawn {
            return Err(VaultError::AdvanceAlreadyDrawn);
        }
        if !metadata.is_funded {
            return Err(VaultError::InsufficientPoolFunding);
        }

        let usdc_token: Address = env.storage().instance().get(&DataKey::UsdcToken).ok_or(VaultError::NotInitialized)?;
        let client = token::Client::new(&env, &usdc_token);

        // Disburse advance to artist
        client.transfer(&env.current_contract_address(), &artist, &metadata.max_advance_usd);

        metadata.advance_drawn = true;
        env.storage().instance().set(&DataKey::Metadata, &metadata);

        Ok(())
    }

    /// Real-time streaming micro-payout distributor (called by DSP oracle/distributor)
    pub fn distribute_stream_revenue(
        env: Env,
        distributor: Address,
        gross_amount: i128,
    ) -> Result<(), VaultError> {
        distributor.require_auth();

        if gross_amount <= 0 {
            return Err(VaultError::InvalidAmount);
        }

        let usdc_token: Address = env.storage().instance().get(&DataKey::UsdcToken).ok_or(VaultError::NotInitialized)?;
        let splits: Vec<CollaboratorSplit> = env.storage().instance().get(&DataKey::Splits).ok_or(VaultError::NotInitialized)?;
        let mut total_disbursed: i128 = env.storage().instance().get(&DataKey::TotalRevenueDisbursed).unwrap_or(0i128);

        let client = token::Client::new(&env, &usdc_token);

        // Pull gross royalty deposit from streaming distributor
        client.transfer(&distributor, &env.current_contract_address(), &gross_amount);

        // Distribute micro-dividends according to legally parsed split sheet
        for split in splits.iter() {
            let recipient_payout = (gross_amount * (split.bps as i128)) / 10_000i128;
            if recipient_payout > 0 {
                client.transfer(&env.current_contract_address(), &split.recipient, &recipient_payout);
            }
        }

        total_disbursed = total_disbursed.checked_add(gross_amount).ok_or(VaultError::InvalidAmount)?;
        env.storage().instance().set(&DataKey::TotalRevenueDisbursed, &total_disbursed);

        Ok(())
    }

    // --- VIEW / READ-ONLY METHODS ---

    pub fn get_metadata(env: Env) -> Result<CatalogMetadata, VaultError> {
        env.storage().instance().get(&DataKey::Metadata).ok_or(VaultError::NotInitialized)
    }

    pub fn get_total_invested(env: Env) -> i128 {
        env.storage().instance().get(&DataKey::TotalInvested).unwrap_or(0i128)
    }

    pub fn get_total_disbursed(env: Env) -> i128 {
        env.storage().instance().get(&DataKey::TotalRevenueDisbursed).unwrap_or(0i128)
    }

    pub fn get_splits(env: Env) -> Result<Vec<CollaboratorSplit>, VaultError> {
        env.storage().instance().get(&DataKey::Splits).ok_or(VaultError::NotInitialized)
    }
}

mod test;
