class CatalogPosition {
  final String id;
  final String title;
  final String artist;
  final String dsp; // 'Spotify', 'Apple Music', 'YouTube'
  final String symbol; // e.g. 'LUNA/USDC'
  final double exposureUsd;
  final double ownershipPercent;
  final double roiPercent;
  final double dailyPayoutUsd;
  final String maturityDate;
  final List<double> sparkline;
  final String sorobanContractId;

  const CatalogPosition({
    required this.id,
    required this.title,
    required this.artist,
    required this.dsp,
    required this.symbol,
    required this.exposureUsd,
    required this.ownershipPercent,
    required this.roiPercent,
    required this.dailyPayoutUsd,
    required this.maturityDate,
    required this.sparkline,
    required this.sorobanContractId,
  });

  static List<CatalogPosition> mockPositions = [
    const CatalogPosition(
      id: 'cat_01',
      title: 'Midnight Echoes (EP)',
      artist: 'Luna Ray',
      dsp: 'Spotify',
      symbol: 'LUNA / USDC',
      exposureUsd: 84200.0,
      ownershipPercent: 82.4,
      roiPercent: 9.2,
      dailyPayoutUsd: 743.20,
      maturityDate: 'Jun 12, 2027',
      sparkline: [12, 14, 13, 16, 18, 17, 21, 24, 23, 27],
      sorobanContractId: 'CC3L...9XA4',
    ),
    const CatalogPosition(
      id: 'cat_02',
      title: 'Neon Horizons',
      artist: 'DJ Kairo (UKG)',
      dsp: 'Apple Music',
      symbol: 'KAIRO / USDC',
      exposureUsd: 52100.0,
      ownershipPercent: 75.1,
      roiPercent: 6.8,
      dailyPayoutUsd: 412.70,
      maturityDate: 'May 28, 2027',
      sparkline: [18, 17, 19, 18, 20, 22, 21, 23, 26, 28],
      sorobanContractId: 'CB7M...4KR8',
    ),
    const CatalogPosition(
      id: 'cat_03',
      title: 'London Rain',
      artist: 'Althea & The Vibe',
      dsp: 'Spotify',
      symbol: 'ALTHEA / USDC',
      exposureUsd: 39100.0,
      ownershipPercent: 68.3,
      roiPercent: 4.3,
      dailyPayoutUsd: 256.90,
      maturityDate: 'Jun 05, 2027',
      sparkline: [10, 11, 13, 12, 15, 14, 17, 19, 18, 22],
      sorobanContractId: 'CA2P...1LQ9',
    ),
    const CatalogPosition(
      id: 'cat_04',
      title: 'Solar Flare',
      artist: 'Nova Collective',
      dsp: 'YouTube',
      symbol: 'NOVA / USDC',
      exposureUsd: 27800.0,
      ownershipPercent: 85.7,
      roiPercent: 7.1,
      dailyPayoutUsd: 298.40,
      maturityDate: 'Jun 18, 2027',
      sparkline: [15, 14, 16, 18, 17, 19, 21, 20, 24, 25],
      sorobanContractId: 'CD8Q...7TR3',
    ),
    const CatalogPosition(
      id: 'cat_05',
      title: 'Silk & Sand',
      artist: 'Maya Lin',
      dsp: 'Spotify',
      symbol: 'MAYA / USDC',
      exposureUsd: 23600.0,
      ownershipPercent: 79.8,
      roiPercent: 5.4,
      dailyPayoutUsd: 184.30,
      maturityDate: 'Jun 02, 2027',
      sparkline: [8, 9, 10, 12, 11, 14, 15, 16, 17, 19],
      sorobanContractId: 'CF5N...8WS2',
    ),
  ];
}
