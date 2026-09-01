class AIUnderwriteResult {
  final String artistName;
  final String trackOrAlbum;
  final double monthlyListeners;
  final double totalStreams;
  final double riskScore; // 0 - 100
  final String riskGrade; // e.g. 'A+', 'A', 'B+'
  final double fairAdvanceUsd;
  final double projected12MoRevenueUsd;
  final double suggestedApy;
  final double decayRateAnnualPercent;
  final double confidenceScore;
  final String aiThesisSummary;
  final List<double> projectedMonthlyCashFlows;
  final List<SplitParty> suggestedSplits;

  const AIUnderwriteResult({
    required this.artistName,
    required this.trackOrAlbum,
    required this.monthlyListeners,
    required this.totalStreams,
    required this.riskScore,
    required this.riskGrade,
    required this.fairAdvanceUsd,
    required this.projected12MoRevenueUsd,
    required this.suggestedApy,
    required this.decayRateAnnualPercent,
    required this.confidenceScore,
    required this.aiThesisSummary,
    required this.projectedMonthlyCashFlows,
    required this.suggestedSplits,
  });
}

class SplitParty {
  final String role; // 'Artist', 'Producer', 'Songwriter', 'Investor Pool'
  final String name;
  final double percentage;
  final String stellarAddress;

  const SplitParty({
    required this.role,
    required this.name,
    required this.percentage,
    required this.stellarAddress,
  });
}
