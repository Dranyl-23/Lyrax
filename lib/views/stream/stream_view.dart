import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../services/stellar_service.dart';

class StreamView extends StatefulWidget {
  const StreamView({super.key});

  @override
  State<StreamView> createState() => _StreamViewState();
}

class _StreamViewState extends State<StreamView> {
  final _stellarService = StellarService();
  Timer? _tickerTimer;

  double _totalStreamedUsdc = 2842.10;
  int _totalStreamsCount = 748190;
  final int _activeListeners = 14250;
  bool _isStreaming = true;

  final List<Map<String, dynamic>> _liveTransactions = [];

  @override
  void initState() {
    super.initState();
    _startLiveStreamTicker();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    super.dispose();
  }

  void _startLiveStreamTicker() {
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 1600), (timer) {
      if (!mounted || !_isStreaming) return;

      final random = Random();
      final double microAmount = 0.04 + (random.nextDouble() * 0.08);
      final int newStreams = 12 + random.nextInt(18);

      final tx = _stellarService.generateMicroPayoutTransaction(
        catalogId: 'LUNA-EP-01',
        grossStreamRevenueUsd: microAmount,
        recipientCount: 42,
      );

      setState(() {
        _totalStreamedUsdc += microAmount;
        _totalStreamsCount += newStreams;
        _liveTransactions.insert(0, tx);
        if (_liveTransactions.length > 20) {
          _liveTransactions.removeLast();
        }
      });
    });
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
                      Row(
                        children: [
                          const Text(
                            'Live Stream Payouts',
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
                              color: AppColors.successGreen.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              children: [
                                CircleAvatar(radius: 3, backgroundColor: AppColors.successGreen),
                                SizedBox(width: 4),
                                Text(
                                  'ACTIVE DSP FEED',
                                  style: TextStyle(color: AppColors.successGreen, fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Sub-cent streaming dividends settling continuously on Stellar',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _isStreaming = !_isStreaming);
                    },
                    icon: Icon(
                      _isStreaming ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: AppColors.primaryPink,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Live Cumulative Ticker Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E1325), Color(0xFF111118)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorderGlowing, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPink.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'TOTAL STREAMING REVENUE DISBURSED',
                      style: TextStyle(
                        color: AppColors.primaryPink,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_totalStreamedUsdc.toStringAsFixed(4)} USDC',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_totalStreamsCount.toString()} verified streams • $_activeListeners concurrent listeners',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Killer Stellar Differentiator Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bolt, color: AppColors.primaryPink, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Why Stellar Makes This Possible',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ethereum micro-payouts fail because gas fees (\$1-\$5) exceed the streaming dividend (\$0.05). On Stellar, settlement takes 2.8 seconds and costs < \$0.00001, making near-real-time streaming royalty payouts economically viable for indie artists!',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 11, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _metricBadge('Settlement Finality', '2.8 sec', Icons.speed),
                        const SizedBox(width: 8),
                        _metricBadge('Average Network Fee', '< \$0.00001', Icons.savings),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Live Soroban Micro-Transactions Header
              const Text(
                'LIVE SOROBAN DISBURSEMENT FEED',
                style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.6),
              ),
              const SizedBox(height: 10),

              if (_liveTransactions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: AppColors.primaryPink),
                  ),
                )
              else
                ..._liveTransactions.map((tx) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryPink.withValues(alpha: 0.15),
                          ),
                          child: const Icon(Icons.check, size: 16, color: AppColors.primaryPink),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '+\$${(tx['totalDisbursedUsd'] as double).toStringAsFixed(4)} USDC',
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '→ ${tx['recipients']} holders',
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Tx: ${(tx['txHash'] as String).substring(0, 14)}... • Ledger #${tx['ledgerSequence']}',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 9.5),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPink.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'FEE <\$0.0001',
                                style: TextStyle(color: AppColors.primaryPink, fontSize: 8.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Stellar Testnet',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardSurfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primaryPink),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 8.5)),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
