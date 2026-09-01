# LyraX Soroban Smart Contract Deployment Script for Stellar Testnet
Write-Host "==========================================================" -ForegroundColor Magenta
Write-Host "  LyraX - Stellar Soroban Smart Contract Deployment Tool  " -ForegroundColor Magenta
Write-Host "==========================================================" -ForegroundColor Magenta

# 1. Check stellar CLI
if (-not (Get-Command "stellar" -ErrorAction SilentlyContinue)) {
    Write-Error "Stellar CLI not found. Please install via: cargo install --locked stellar-cli"
    exit 1
}

Write-Host "`n[1/4] Generating & Funding Testnet Admin Keypair..." -ForegroundColor Cyan
stellar keys generate --network testnet lyrax-admin --overwrite
stellar keys fund --network testnet lyrax-admin
$adminAddr = stellar keys address lyrax-admin
Write-Host "Admin Public Key: $adminAddr" -ForegroundColor Green

Write-Host "`n[2/4] Building Soroban Contracts (catalog_vault & royalty_token)..." -ForegroundColor Cyan
stellar contract build

Write-Host "`n[3/4] Deploying CatalogVault to Stellar Testnet..." -ForegroundColor Cyan
$vaultWasm = "target/wasm32-unknown-unknown/release/catalog_vault.wasm"
if (Test-Path $vaultWasm) {
    $vaultId = stellar contract deploy --wasm $vaultWasm --source lyrax-admin --network testnet
    Write-Host "CatalogVault Contract ID: $vaultId" -ForegroundColor Green
    Write-Host "View on Stellar Expert: https://stellar.expert/explorer/testnet/contract/$vaultId" -ForegroundColor Yellow
} else {
    Write-Warning "WASM binary not found at $vaultWasm. Ensure Rust wasm32-unknown-unknown target is installed."
}

Write-Host "`n[4/4] Setup complete! Use 'stellar contract invoke' to interact." -ForegroundColor Magenta
