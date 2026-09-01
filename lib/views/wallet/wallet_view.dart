import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../services/stellar_service.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final _stellarService = StellarService();
  bool _isAirdropping = false;

  @override
  void initState() {
    super.initState();
    if (_stellarService.accountId.isEmpty) {
      _stellarService.initDemoWallet();
    }
  }

  Future<void> _airdrop() async {
    setState(() => _isAirdropping = true);
    await _stellarService.requestFriendbotAirdrop();
    if (mounted) {
      setState(() => _isAirdropping = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Airdropped 10,000 Testnet XLM via Stellar Friendbot!'),
          backgroundColor: AppColors.primaryPink,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Stellar Demo Wallet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const CircleAvatar(radius: 3, backgroundColor: AppColors.successGreen),
                          const SizedBox(width: 5),
                          const Text(
                            'Connected to Stellar Testnet (Soroban)',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBorderGlowing),
                    ),
                    child: const Text(
                      'TESTNET',
                      style: TextStyle(color: AppColors.primaryPink, fontSize: 9, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Wallet Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF221326), Color(0xFF14141E)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorderGlowing, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL LIQUIDITY',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _stellarService.accountId.length > 10
                                    ? '${_stellarService.accountId.substring(0, 4)}...${_stellarService.accountId.substring(_stellarService.accountId.length - 4)}'
                                    : 'Demo Key',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: _stellarService.accountId));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Address copied to clipboard!')),
                                  );
                                },
                                child: const Icon(Icons.copy, size: 12, color: AppColors.primaryPink),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$${(_stellarService.usdcBalance + (_stellarService.xlmBalance * 0.12)).toStringAsFixed(2)} USD',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.cardSurface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('USDC Balance', style: TextStyle(color: AppColors.textMuted, fontSize: 9.5)),
                                const SizedBox(height: 2),
                                Text('\$${_stellarService.usdcBalance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.cardSurface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Stellar Native (XLM)', style: TextStyle(color: AppColors.textMuted, fontSize: 9.5)),
                                const SizedBox(height: 2),
                                Text('${_stellarService.xlmBalance.toStringAsFixed(0)} XLM', style: const TextStyle(color: AppColors.primaryPink, fontSize: 13, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _isAirdropping ? null : _airdrop,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isAirdropping
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.volunteer_activism, size: 16),
                            SizedBox(width: 8),
                            Text('Fund Wallet via Friendbot (+10,000 XLM)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 18),

              // Active Tokenized Royalty Holdings on Soroban
              const Text(
                'YOUR TOKENIZED ROYALTY ASSETS',
                style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.6),
              ),
              const SizedBox(height: 10),

              _holdingCard('Midnight Echoes (EP)', 'Luna Ray', '82.4%', '\$84,200', 'SEP-41 Soroban Token'),
              _holdingCard('Neon Horizons (Single)', 'DJ Kairo', '75.1%', '\$52,100', 'SEP-41 Soroban Token'),
              _holdingCard('Solar Flare (EP)', 'Nova Collective', '85.7%', '\$27,800', 'SEP-41 Soroban Token'),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _holdingCard(String title, String artist, String share, String val, String tokenType) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('$artist • $tokenType', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(val, style: const TextStyle(color: AppColors.primaryPink, fontSize: 12.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('$share pool ownership', style: const TextStyle(color: AppColors.textSecondary, fontSize: 9.5)),
            ],
          ),
        ],
      ),
    );
  }
}
