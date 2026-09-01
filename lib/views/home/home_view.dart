import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/catalog_position.dart';
import 'widgets/metric_card.dart';
import 'widgets/sparkline_widget.dart';
import 'widgets/circular_gauge_widget.dart';
import 'widgets/mini_bar_chart_widget.dart';
import 'widgets/cash_flow_line_chart.dart';
import 'widgets/catalog_position_tile.dart';
import 'widgets/app_side_drawer.dart';
import 'widgets/filter_bottom_sheet.dart';

class HomeView extends StatefulWidget {
  final VoidCallback? onOpenAiScanner;
  final VoidCallback? onOpenStreamView;

  const HomeView({
    super.key,
    this.onOpenAiScanner,
    this.onOpenStreamView,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isCreatorMode = true;
  String _selectedCurrency = 'USD';
  FilterCriteria _currentFilter = FilterCriteria.defaultCriteria;

  List<CatalogPosition> get _filteredPositions {
    return CatalogPosition.mockPositions.where((pos) {
      // Genre filter
      if (_currentFilter.genre != 'All') {
        final g = _currentFilter.genre.toLowerCase();
        final match = pos.artist.toLowerCase().contains(g) ||
            pos.title.toLowerCase().contains(g) ||
            (g.contains('garage') && pos.artist.contains('UKG'));
        if (!match) return false;
      }
      // Risk filter
      if (_currentFilter.riskGrade != 'All') {
        if (_currentFilter.riskGrade == 'Grade A+' && pos.roiPercent < 7.0) return false;
      }
      // Min APY filter
      if (pos.roiPercent < (_currentFilter.minApy - 3.0)) return false;

      return true;
    }).toList();
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FilterBottomSheet(
        currentCriteria: _currentFilter,
        onApply: (newCriteria) {
          setState(() => _currentFilter = newCriteria);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Applied filters: ${_currentFilter.genre} • Min ${_currentFilter.minApy.toStringAsFixed(1)}% APY'),
              backgroundColor: AppColors.primaryPink,
            ),
          );
        },
      ),
    );
  }

  String get _currencySymbol => _selectedCurrency == 'USD' ? '\$' : (_selectedCurrency == 'GBP' ? '£' : '€');

  @override
  Widget build(BuildContext context) {
    final displayedList = _filteredPositions;
    final bool hasActiveFilter = _currentFilter.genre != 'All' || _currentFilter.riskGrade != 'All' || _currentFilter.minApy > 8.0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: AppSideDrawer(
        isCreatorMode: _isCreatorMode,
        onModeChanged: (val) {
          setState(() => _isCreatorMode = val);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(val ? 'Switched to Creator Mode (Artist Portal)' : 'Switched to Investor Mode (Liquidity Backer)'),
              backgroundColor: AppColors.primaryPink,
            ),
          );
        },
        selectedCurrency: _selectedCurrency,
        onCurrencyChanged: (val) {
          setState(() => _selectedCurrency = val);
          Navigator.pop(context);
        },
        onOpenAiScanner: widget.onOpenAiScanner,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar / Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Hamburger Button (Opens Side Drawer)
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: const Icon(Icons.menu, size: 20, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _isCreatorMode ? 'Creator Treasury' : 'Investor Portfolio',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPink.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.primaryPink, width: 0.5),
                                ),
                                child: const Text(
                                  'STELLAR',
                                  style: TextStyle(
                                    color: AppColors.primaryPink,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isCreatorMode
                                ? 'Luna Ray • Spotify Connected (142.5K Listeners)'
                                : 'Real-time multi-DSP catalog underwriting & micro-payouts',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Tune / Filter Button (Opens Filter Bottom Sheet)
                  GestureDetector(
                    onTap: _openFilterBottomSheet,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: hasActiveFilter ? AppColors.primaryPink.withValues(alpha: 0.2) : AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: hasActiveFilter ? AppColors.primaryPink : AppColors.cardBorder,
                        ),
                      ),
                      child: Icon(
                        Icons.tune,
                        size: 18,
                        color: hasActiveFilter ? AppColors.primaryPink : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Active Filter Bar (if applied)
              if (hasActiveFilter) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primaryPink.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_alt, size: 11, color: AppColors.primaryPink),
                          const SizedBox(width: 4),
                          Text(
                            'Filters: ${_currentFilter.genre} • ${_currentFilter.riskGrade} • Min ${_currentFilter.minApy.toStringAsFixed(0)}% APY',
                            style: const TextStyle(color: AppColors.primaryPink, fontSize: 9.5, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => setState(() => _currentFilter = FilterCriteria.defaultCriteria),
                      child: const Text('Clear', style: TextStyle(color: AppColors.textMuted, fontSize: 10, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],

              // 2x2 Metric Grid
              Row(
                children: [
                  // Card 1: Total Exposure
                  Expanded(
                    child: MetricCard(
                      label: _isCreatorMode ? 'CATALOG VALUATION' : 'TOTAL EXPOSURE',
                      value: '$_currencySymbol 148.5M',
                      subtitle: '$_selectedCurrency Equivalent',
                      visualContent: const SparklineWidget(
                        data: [12, 14, 13, 17, 19, 18, 22, 25, 23, 29],
                        height: 36,
                        color: AppColors.primaryPink,
                      ),
                      deltaText: '12.4% vs last 24h',
                      isPositive: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Card 2: AI Underwrite Score (Circular Gauge)
                  Expanded(
                    child: MetricCard(
                      label: 'AI UNDERWRITE SCORE',
                      value: '94.2%',
                      subtitle: 'Grade A+ • Collateralized',
                      visualContent: const CircularGaugeWidget(
                        percentage: 94.2,
                        size: 58,
                      ),
                      deltaText: '98.6% model confidence',
                      isPositive: true,
                      onTap: widget.onOpenAiScanner,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Card 3: Est. Royalty Yield
                  Expanded(
                    child: MetricCard(
                      label: _isCreatorMode ? 'ROYALTIES EARNED' : 'EST. STREAM YIELD',
                      value: '$_currencySymbol 2,842.10',
                      subtitle: 'Stellar USDC Settled',
                      visualContent: const SparklineWidget(
                        data: [15, 17, 16, 20, 19, 23, 26, 25, 29, 32],
                        height: 36,
                        color: AppColors.primaryPink,
                      ),
                      deltaText: '8.7% vs last 24h',
                      isPositive: true,
                      onTap: widget.onOpenStreamView,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Card 4: Rate Stability / Daily Velocity
                  Expanded(
                    child: MetricCard(
                      label: 'STREAM STABILITY',
                      value: '96.2%',
                      subtitle: '7D Retention Score',
                      visualContent: const MiniBarChartWidget(
                        values: [12, 18, 14, 22, 28, 24, 30, 26, 32, 36, 34, 38],
                        height: 36,
                        color: AppColors.primaryPink,
                      ),
                      deltaText: '2.1% vs last 7d',
                      isPositive: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Interactive Chart Section
              const CashFlowLineChart(),
              const SizedBox(height: 18),

              // Royalty Positions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _isCreatorMode ? 'Your Tokenized Catalogs' : 'Royalty Positions',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Viewing all ${displayedList.length} tokenized catalogs on Stellar Soroban'),
                          backgroundColor: AppColors.cardSurfaceElevated,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'View All (${displayedList.length})',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Positions Table (Horizontally scrollable on narrow mobile screens)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: 440,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(width: 32),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'CATALOG / ASSET',
                                style: TextStyle(color: AppColors.textMuted, fontSize: 8.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'EXPOSURE (USD)',
                                style: TextStyle(color: AppColors.textMuted, fontSize: 8.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'SHARE %',
                                style: TextStyle(color: AppColors.textMuted, fontSize: 8.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'DAILY YIELD',
                                textAlign: TextAlign.end,
                                style: TextStyle(color: AppColors.textMuted, fontSize: 8.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'MATURITY',
                                textAlign: TextAlign.end,
                                style: TextStyle(color: AppColors.textMuted, fontSize: 8.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.cardBorder, height: 1),
                      // List of filtered positions
                      if (displayedList.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No catalogs match this filter criteria',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                            ),
                          ),
                        )
                      else
                        ...displayedList.map((pos) => CatalogPositionTile(
                              position: pos,
                              onTap: () => _showCatalogDetailSheet(context, pos),
                            )),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80), // Space for floating bottom nav
            ],
          ),
        ),
      ),
    );
  }

  void _showCatalogDetailSheet(BuildContext context, CatalogPosition pos) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pos.title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primaryPink),
                  ),
                  child: Text(
                    pos.symbol,
                    style: const TextStyle(color: AppColors.primaryPink, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('Artist: ${pos.artist} • DSP Feed: ${pos.dsp}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _infoBlock('Soroban Contract', pos.sorobanContractId),
                ),
                Expanded(
                  child: _infoBlock('Daily Payout', '\$${pos.dailyPayoutUsd.toStringAsFixed(2)} USDC'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _infoBlock('Catalog Valuation', '\$${pos.exposureUsd.toStringAsFixed(0)}'),
                ),
                Expanded(
                  child: _infoBlock('Investor Pool Share', '${pos.ownershipPercent}%'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Streaming micro-payouts triggered for ${pos.title} on Stellar Testnet!'),
                    backgroundColor: AppColors.primaryPink,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Execute Soroban Micro-Dividend Payout', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
