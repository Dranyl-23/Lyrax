import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

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
                      Row(
                        children: [
                          const Text(
                            'Catalog Analytics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPink.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.primaryPink, width: 0.5),
                            ),
                            child: const Text(
                              'AI SENTINEL',
                              style: TextStyle(color: AppColors.primaryPink, fontSize: 8.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Decay half-life curve modeling & fraud anomaly detection',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cardBorderGlowing),
                    ),
                    child: const Icon(Icons.analytics_outlined, color: AppColors.primaryPink, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // SECTION 1: CATALOG DECAY CURVE & HALF-LIFE
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF221326), Color(0xFF13131B)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorderGlowing, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CATALOG HALF-LIFE BENCHMARK',
                          style: TextStyle(color: AppColors.primaryPink, fontSize: 9.5, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'GRADE A+ COLLATERAL',
                            style: TextStyle(color: AppColors.successGreen, fontSize: 8.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '18.4 Months',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Catalog retention velocity is 42% higher than pop baseline. Monthly decay plateau stabilizes at 8.4%/year.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _metricBadge('Decay Floor', '8.4% / yr', Icons.trending_down),
                        const SizedBox(width: 8),
                        _metricBadge('DSP Retention', '96.2%', Icons.verified),
                        const SizedBox(width: 8),
                        _metricBadge('Recoupment Est.', '7.2 Mos', Icons.hourglass_top),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // SECTION 2: TERRITORY REVENUE BREAKDOWN
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Territory Revenue Share',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '4 MAJOR MARKETS',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 9.5, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _territoryRow('🇬🇧 United Kingdom', 45, '£0.0042 / stream', isPrimary: true),
                    const SizedBox(height: 10),
                    _territoryRow('🇺🇸 United States', 30, '\$0.0039 / stream'),
                    const SizedBox(height: 10),
                    _territoryRow('🇪🇺 Europe (DE / FR)', 15, '€0.0040 / stream'),
                    const SizedBox(height: 10),
                    _territoryRow('🌍 Rest of World', 10, '\$0.0028 / stream'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // SECTION 3: AI FRAUD & ANOMALY SENTINEL (INVESTOR PROTECTION)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined, color: AppColors.primaryPink, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'AI Fraud & Bot-Stream Sentinel',
                              style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('0 BOT FARMS', style: TextStyle(color: AppColors.successGreen, fontSize: 8.5, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Monitors streaming streams across Spotify, Apple Music, and YouTube to prevent bot-farming clawbacks before releasing Soroban funds.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 11, height: 1.35),
                    ),
                    const SizedBox(height: 12),
                    _sentinelAuditTile(
                      status: 'PASSED',
                      title: 'IP Cluster & Velocity Check',
                      detail: '0.02% variance detected. Highly distributed human listeners.',
                      time: '2 mins ago',
                    ),
                    _sentinelAuditTile(
                      status: 'PASSED',
                      title: 'Loop-Listening Anomaly Pattern',
                      detail: 'Natural human skip rate at 18.4%. No 24-hour replay loops.',
                      time: '8 mins ago',
                    ),
                    _sentinelAuditTile(
                      status: 'PASSED',
                      title: 'DSP Geographic Correlation',
                      detail: 'Organic TikTok UK Garage viral growth confirmed.',
                      time: '24 mins ago',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricBadge(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cardSurfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 13, color: AppColors.primaryPink),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 8.5)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _territoryRow(String country, double percent, String rate, {bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(country, style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal)),
            Row(
              children: [
                Text('${percent.toStringAsFixed(0)}%  ', style: const TextStyle(color: AppColors.primaryPink, fontSize: 11, fontWeight: FontWeight.bold)),
                Text('($rate)', style: const TextStyle(color: AppColors.textMuted, fontSize: 9.5)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: AppColors.cardBorder,
            valueColor: AlwaysStoppedAnimation<Color>(isPrimary ? AppColors.primaryPink : AppColors.vibrantPink),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _sentinelAuditTile({
    required String status,
    required String title,
    required String detail,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardSurfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: const TextStyle(color: AppColors.successGreen, fontSize: 8.5, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                Text(detail, style: const TextStyle(color: AppColors.textMuted, fontSize: 9.5)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: AppColors.textMuted, fontSize: 9)),
        ],
      ),
    );
  }
}
