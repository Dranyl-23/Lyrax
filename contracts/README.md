# LyraX Soroban Smart Contracts ⚡🎵

> **Institutional Smart Contracts for Music Royalty Financing & Instant Streaming Payouts on Stellar**

This directory contains the production Soroban smart contracts for **LyraX**:

1. **`catalog_vault` (`contracts/catalog_vault`)**:
   * Stores catalog metadata, AI underwriting risk score ($94.2\%$), and legal collaborator splits.
   * Manages investor USDC deposits to fund creator cash advances ($14,800 USDC limit).
   * Distributes real-time streaming royalties to creators, investors, and producers according to parsed split sheets.
2. **`royalty_token` (`contracts/royalty_token`)**:
   * Standard **SEP-41** compliant fractional royalty share token.
   * Minted to liquidity providers upon catalog funding.

---

## 🏗️ Architecture & Interaction Flow

```
+-----------------------------------------------------------------------------------+
|                            LYRAX SMART CONTRACT ENGINE                            |
+-----------------------------------------------------------------------------------+
|                                                                                   |
|  1. [AI ORACLE] ---> Signed Attestation (LUNA-EP-01, $14.8k Advance, 94.2% A+)   |
|                              |                                                    |
|                              v                                                    |
|  2. [CATALOG VAULT] ---> initialize() stores terms & collaborator splits          |
|                              |                                                    |
|                              v                                                    |
|  3. [INVESTORS]    ---> invest(USDC) deposits liquidity into vault                |
|                              |                                                    |
|                              v                                                    |
|  4. [ARTIST]       ---> draw_advance() claims $14,800 USDC advance                |
|                              |                                                    |
|                              v                                                    |
|  5. [DSP ORACLE]   ---> distribute_stream_revenue() splits incoming royalties:    |
|                         • 60% to Artist                                           |
|                         • 30% to Investor Vault (Streaming Yield)                 |
|                         • 10% to Producer                                         |
+-----------------------------------------------------------------------------------+
```

---

## 🛠️ Build & Test Commands

### 1. Run Contract Unit Tests
From the `contracts/` directory:
```bash
cargo test
```

### 2. Build Optimized WebAssembly (WASM) Contracts
```bash
stellar contract build
```
This outputs compiled, optimized WASM binaries to `target/wasm32-unknown-unknown/release/`.

---

## 🚀 Deployment to Stellar Testnet

### Step 1: Generate & Fund Testnet Keypair
```bash
# Generate keypair named 'lyrax-admin'
stellar keys generate --network testnet lyrax-admin

# Request testnet XLM from Friendbot
stellar keys fund --network testnet lyrax-admin
```

### Step 2: Deploy `catalog_vault` Contract
```bash
stellar contract deploy \
  --wasm target/wasm32-unknown-unknown/release/catalog_vault.wasm \
  --source lyrax-admin \
  --network testnet
```
*Output: Contract ID (e.g. `CC3L9XA4LYRAXTESTNET...`)*

### Step 3: Initialize Catalog Vault
```bash
stellar contract invoke \
  --id <CONTRACT_ID> \
  --source lyrax-admin \
  --network testnet \
  -- \
  initialize \
  --admin lyrax-admin \
  --usdc_token <USDC_SAC_ADDRESS> \
  --artist <ARTIST_PUBLIC_KEY> \
  --catalog_id "LUNA01" \
  --total_valuation_usd 1485000000000 \
  --max_advance_usd 148000000000 \
  --risk_score_bps 9420 \
  --splits '[{"recipient":"<ARTIST_ADDR>","bps":6000,"role":"ARTIST"},{"recipient":"<VAULT_ADDR>","bps":3000,"role":"VAULT"},{"recipient":"<PRODUCER_ADDR>","bps":1000,"role":"PRODUCER"}]'
```

### Step 4: Stream Revenue Micro-Distribution
```bash
stellar contract invoke \
  --id <CONTRACT_ID> \
  --source lyrax-admin \
  --network testnet \
  -- \
  distribute_stream_revenue \
  --distributor lyrax-admin \
  --gross_amount 100000000
```
