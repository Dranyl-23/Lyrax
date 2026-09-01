import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AppSideDrawer extends StatelessWidget {
  final bool isCreatorMode;
  final ValueChanged<bool> onModeChanged;
  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback? onOpenAiScanner;

  const AppSideDrawer({
    super.key,
    required this.isCreatorMode,
    required this.onModeChanged,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    this.onOpenAiScanner,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardSurface,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // App Brand Header
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primaryPink.withValues(alpha: 0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryPink.withValues(alpha: 0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.asset('assets/Lyrax-logo.png', fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'LyraX',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'PROTOCOL',
                                style: TextStyle(color: AppColors.primaryPink, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            'AI Royalty Financing on Stellar',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 10.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Stellar Testnet Status Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1A12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(radius: 3.5, backgroundColor: AppColors.successGreen),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Stellar Testnet • Soroban Active',
                            style: TextStyle(color: AppColors.successGreen, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '28ms',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 9.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ROLE SWITCHER: Creator vs Investor Mode
                  const Text(
                    'PORTAL MODE',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        // Creator Option
                        Expanded(
                          child: GestureDetector(
                            onTap: () => onModeChanged(true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isCreatorMode ? AppColors.primaryPink : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.mic_none,
                                    size: 14,
                                    color: isCreatorMode ? Colors.white : AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Creator Mode',
                                    style: TextStyle(
                                      color: isCreatorMode ? Colors.white : AppColors.textMuted,
                                      fontSize: 11,
                                      fontWeight: isCreatorMode ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Investor Option
                        Expanded(
                          child: GestureDetector(
                            onTap: () => onModeChanged(false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !isCreatorMode ? AppColors.primaryPink : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pie_chart_outline,
                                    size: 14,
                                    color: !isCreatorMode ? Colors.white : AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Investor Mode',
                                    style: TextStyle(
                                      color: !isCreatorMode ? Colors.white : AppColors.textMuted,
                                      fontSize: 11,
                                      fontWeight: !isCreatorMode ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Mode description callout
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPink.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryPink.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      isCreatorMode
                          ? '🎵 Creator Mode Active: You can connect DSP catalogs, request instant AI-underwritten USDC advances, and manage royalty split agreements.'
                          : '💼 Investor Mode Active: You can explore tokenized music catalogs, analyze projected yield APY, and earn automated streaming micro-dividends.',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // SPOTIFY FOR ARTISTS CONNECTION
                  const Text(
                    'STREAMING DISTRIBUTOR ORACLE',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1DB954), // Spotify Green
                              ),
                              child: const Icon(Icons.music_note, color: Colors.white, size: 14),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Spotify for Artists',
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Connected • Luna Ray (142.5K)',
                                    style: TextStyle(color: AppColors.textMuted, fontSize: 9.5),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle, color: Color(0xFF1DB954), size: 16),
                          ],
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Synchronized latest 24-hour Spotify & Apple Music streaming telemetry!'),
                                backgroundColor: Color(0xFF1DB954),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1DB954), width: 1),
                            foregroundColor: const Color(0xFF1DB954),
                            minimumSize: const Size(double.infinity, 32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sync, size: 12),
                              SizedBox(width: 6),
                              Text('Sync DSP Telemetry', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // DISPLAY CURRENCY SELECTOR
                  const Text(
                    'BASE CURRENCY',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['USD', 'GBP', 'EUR'].map((currency) {
                      final bool isSelected = selectedCurrency == currency;
                      final String symbol = currency == 'USD' ? '\$' : (currency == 'GBP' ? '£' : '€');
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: GestureDetector(
                            onTap: () => onCurrencyChanged(currency),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryPink.withValues(alpha: 0.2) : AppColors.cardSurfaceElevated,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryPink : AppColors.cardBorder,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$symbol $currency',
                                  style: TextStyle(
                                    color: isSelected ? AppColors.primaryPink : AppColors.textSecondary,
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // QUICK LINKS
                  const Text(
                    'COMMUNITY & HACKATHON',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 8),
                  _navLink(Icons.flight_takeoff, 'London Builder HQ → Lisbon', 'Road to HackMeridian 2026', () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('H.E.R. DAO Community Partner: Road to Lisbon ✈️')),
                    );
                  }),
                  _navLink(Icons.smart_toy_outlined, 'AI Underwriter Model', 'Powered by LyraX Predictive Engine', () {
                    Navigator.pop(context);
                    onOpenAiScanner?.call();
                  }),
                  _navLink(Icons.open_in_new, 'Stellar Soroban Explorer', 'Inspect contracts on Testnet', () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening stellar.expert testnet explorer...')),
                    );
                  }),
                ],
              ),
            ),

            // Footer
            const Divider(color: AppColors.cardBorder, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('LyraX v1.0.0', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPink.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('H.E.R. DAO Tagged', style: TextStyle(color: AppColors.primaryPink, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navLink(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryPink),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600)),
                    Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 9.5)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
