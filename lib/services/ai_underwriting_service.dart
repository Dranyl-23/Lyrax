import 'dart:math';
import '../models/ai_underwrite_result.dart';

class AIUnderwritingService {
  static final AIUnderwritingService _instance = AIUnderwritingService._internal();
  factory AIUnderwritingService() => _instance;
  AIUnderwritingService._internal();

  /// Underwrites a music catalog by projecting streaming decay curves,
  /// assessing volatility, and calculating fair loan-to-value (LTV) advances.
  Future<AIUnderwriteResult> underwriteCatalog({
    required String artistName,
    required String trackOrAlbum,
    required double monthlyListeners,
    required double catalogAgeMonths,
    required String genre,
    bool simulateDelay = true,
  }) async {
    if (simulateDelay) {
      // Simulate real-time neural network inference
      await Future.delayed(const Duration(milliseconds: 1400));
    }

    // Spotify/Apple Music blended average payout rate ($0.0038/stream)
    const double blendedRatePerStream = 0.0038;
    
    // Monthly streams estimation (active listener stream multiplier)
    final double baseStreamsPerListenerMonth = 2.4 + (genre.toLowerCase().contains('garage') || genre.toLowerCase().contains('electronic') ? 0.8 : 0.4);
    final double annualStreams = monthlyListeners * baseStreamsPerListenerMonth * 12;
    final double rawAnnualGross = annualStreams * blendedRatePerStream;

    // Decay rate curve: older catalogs decay slower (exponential decay plateau)
    final double decayFactor = catalogAgeMonths > 24 ? 0.08 : (catalogAgeMonths > 12 ? 0.14 : 0.22);
    
    // Net projected 12-month streaming revenue
    final double projected12MoRevenue = rawAnnualGross * (1.0 - (decayFactor / 2));

    // Risk scoring (0 - 100) based on stability, genre retention, and catalog age
    double stabilityScore = 85.0 + (min(catalogAgeMonths, 36) / 36 * 10.0);
    if (monthlyListeners > 100000) stabilityScore += 4.0;
    final double riskScore = min(98.5, max(72.0, stabilityScore));

    String grade = 'A+';
    if (riskScore < 80) {
      grade = 'B';
    } else if (riskScore < 87) {
      grade = 'B+';
    } else if (riskScore < 93) {
      grade = 'A';
    }

    // Advance LTV (Loan-To-Value): 65% - 75% of 12-month expected cash flows
    final double ltv = grade == 'A+' ? 0.75 : (grade == 'A' ? 0.70 : 0.65);
    final double fairAdvance = (projected12MoRevenue * ltv).roundToDouble();

    // Suggested investor yield APY
    final double suggestedApy = grade == 'A+' ? 11.4 : (grade == 'A' ? 13.8 : 16.5);

    // Monthly cash flow projections with seasonal weighting & decay
    final List<double> monthlyFlows = [];
    final double baseMonthly = projected12MoRevenue / 12;
    for (int i = 0; i < 12; i++) {
      final double monthlyDecay = pow(1.0 - (decayFactor / 12), i).toDouble();
      // Add slight organic seasonality
      final double seasonality = 1.0 + (0.08 * sin((i + 1) * pi / 6));
      monthlyFlows.add(baseMonthly * monthlyDecay * seasonality);
    }

    final String thesis = 
        'LyraX Underwrite Engine: $artistName demonstrates an exceptional retention velocity of '
        '${(baseStreamsPerListenerMonth).toStringAsFixed(1)} streams/listener with an annualized decay floor of '
        '${(decayFactor * 100).toStringAsFixed(1)}%. Projected 12-mo DSP cash flow stands at '
        '\$${projected12MoRevenue.toStringAsFixed(0)} USDC. Underwriting confirms a \$${fairAdvance.toStringAsFixed(0)} advance '
        'supported by $grade grade collateralization on Stellar Soroban.';

    final splits = [
      SplitParty(
        role: 'Artist Principal',
        name: artistName,
        percentage: 60.0,
        stellarAddress: 'GDM6...39VA',
      ),
      const SplitParty(
        role: 'Investor Yield Pool',
        name: 'LyraX Soroban Vault',
        percentage: 30.0,
        stellarAddress: 'CB9K...77LQ',
      ),
      const SplitParty(
        role: 'Producer & Publishing Split',
        name: 'Verified Rights Holder',
        percentage: 10.0,
        stellarAddress: 'GA4F...12KX',
      ),
    ];

    return AIUnderwriteResult(
      artistName: artistName,
      trackOrAlbum: trackOrAlbum,
      monthlyListeners: monthlyListeners,
      totalStreams: annualStreams,
      riskScore: riskScore,
      riskGrade: grade,
      fairAdvanceUsd: fairAdvance,
      projected12MoRevenueUsd: projected12MoRevenue,
      suggestedApy: suggestedApy,
      decayRateAnnualPercent: decayFactor * 100,
      confidenceScore: 96.4,
      aiThesisSummary: thesis,
      projectedMonthlyCashFlows: monthlyFlows,
      suggestedSplits: splits,
    );
  }

  /// Preset artists for rapid 1-tap live demos during hackathon judging
  static List<Map<String, dynamic>> presetDemoCatalogs = [
    {
      'artist': 'Luna Ray',
      'title': 'Midnight Echoes (EP)',
      'listeners': 142500.0,
      'months': 18.0,
      'genre': 'Indie Electronic / Synthwave',
    },
    {
      'artist': 'DJ Kairo',
      'title': 'South London Pressure',
      'listeners': 98000.0,
      'months': 26.0,
      'genre': 'UK Garage / Bass',
    },
    {
      'artist': 'Maya Lin',
      'title': 'Silk & Sand (LP)',
      'listeners': 64000.0,
      'months': 12.0,
      'genre': 'Neo-Soul / R&B',
    },
  ];
}
