import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CashFlowLineChart extends StatefulWidget {
  const CashFlowLineChart({super.key});

  @override
  State<CashFlowLineChart> createState() => _CashFlowLineChartState();
}

class _CashFlowLineChartState extends State<CashFlowLineChart> {
  int selectedDspIndex = 0;
  final List<String> dspTabs = ['ALL DSPs', 'Spotify', 'Apple Music', 'YouTube'];

  String selectedTimeframe = '7D';
  final List<String> timeframes = ['24H', '7D', '30D', '90D', '1Y', 'ALL'];

  // DSP volume weighting
  double get dspMultiplier {
    switch (selectedDspIndex) {
      case 1:
        return 0.62; // Spotify ~62%
      case 2:
        return 0.26; // Apple Music ~26%
      case 3:
        return 0.12; // YouTube ~12%
      default:
        return 1.00; // All DSPs combined
    }
  }

  // Timeframe datasets
  List<String> get xLabels {
    switch (selectedTimeframe) {
      case '24H':
        return ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00', '24:00'];
      case '7D':
        return ['Sep 6', 'Sep 7', 'Sep 8', 'Sep 9', 'Sep 10', 'Sep 11', 'Sep 12'];
      case '30D':
        return ['Aug 15', 'Aug 22', 'Aug 29', 'Sep 5', 'Sep 12'];
      case '90D':
        return ['May', 'Jun', 'Jul', 'Aug', 'Sep'];
      case '1Y':
        return ['Q4 \'25', 'Q1 \'26', 'Q2 \'26', 'Q3 \'26'];
      case 'ALL':
        return ['2023', '2024', '2025', '2026'];
      default:
        return ['Sep 6', 'Sep 7', 'Sep 8', 'Sep 9', 'Sep 10', 'Sep 11', 'Sep 12'];
    }
  }

  List<FlSpot> get actualSpots {
    List<double> rawValues;
    switch (selectedTimeframe) {
      case '24H':
        rawValues = [1420, 1380, 1520, 1780, 1920, 1860, 1842];
        break;
      case '7D':
        rawValues = [1540, 1620, 1580, 1790, 1920, 1842, 1980];
        break;
      case '30D':
        rawValues = [1480, 1600, 1750, 1820, 1842];
        break;
      case '90D':
        rawValues = [1350, 1490, 1620, 1740, 1842];
        break;
      case '1Y':
        rawValues = [1100, 1350, 1620, 1842];
        break;
      case 'ALL':
        rawValues = [820, 1240, 1580, 1842];
        break;
      default:
        rawValues = [1540, 1620, 1580, 1790, 1920, 1842, 1980];
    }

    return List.generate(
      rawValues.length,
      (i) => FlSpot(i.toDouble(), rawValues[i] * dspMultiplier),
    );
  }

  List<FlSpot> get baselineSpots {
    List<double> rawFloors;
    switch (selectedTimeframe) {
      case '24H':
        rawFloors = [1350, 1350, 1400, 1450, 1500, 1500, 1520];
        break;
      case '7D':
        rawFloors = [1420, 1450, 1470, 1500, 1530, 1560, 1580];
        break;
      case '30D':
        rawFloors = [1380, 1420, 1480, 1520, 1560];
        break;
      case '90D':
        rawFloors = [1250, 1350, 1450, 1500, 1550];
        break;
      case '1Y':
        rawFloors = [980, 1200, 1400, 1550];
        break;
      case 'ALL':
        rawFloors = [700, 1050, 1380, 1550];
        break;
      default:
        rawFloors = [1420, 1450, 1470, 1500, 1530, 1560, 1580];
    }

    return List.generate(
      rawFloors.length,
      (i) => FlSpot(i.toDouble(), rawFloors[i] * dspMultiplier),
    );
  }

  double get currentGrossRevenue => (1842.50 * dspMultiplier);
  double get currentPeakRevenue => (2104.00 * dspMultiplier);
  double get currentFloorRevenue => (1420.00 * dspMultiplier);

  void _openTimeframeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select Time Horizon',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'View verified DSP royalties and AI predictive decay trends',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              const SizedBox(height: 14),
              ...timeframes.map((tf) {
                final bool isSelected = selectedTimeframe == tf;
                String desc = 'Last $tf';
                if (tf == '24H') desc = 'Real-time hourly stream velocity';
                if (tf == '7D') desc = 'Daily micro-settlement history';
                if (tf == '30D') desc = 'Monthly playlist stickiness curve';
                if (tf == '90D') desc = 'Quarterly distributor payout window';
                if (tf == '1Y') desc = 'Annual streaming decay model';
                if (tf == 'ALL') desc = 'All-time catalog inception yield';

                return InkWell(
                  onTap: () {
                    setState(() => selectedTimeframe = tf);
                    Navigator.pop(ctx);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryPink.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryPink : AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tf,
                              style: TextStyle(
                                color: isSelected ? AppColors.primaryPink : Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(desc, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                          ],
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: AppColors.primaryPink, size: 16),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spots = actualSpots;
    final floors = baselineSpots;
    final labels = xLabels;

    // Calculate dynamic Y bounds
    final double maxVal = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final double minVal = floors.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final double maxY = (maxVal * 1.15).ceilToDouble();
    final double minY = (minVal * 0.85).floorToDouble();
    final double interval = ((maxY - minY) / 3).clamp(10.0, 1000.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header & Timeframe selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Streaming Revenue Trends',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  // Timeframe Selector Pill (Clickable)
                  GestureDetector(
                    onTap: _openTimeframeSelector,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primaryPink, width: 1),
                      ),
                      child: Row(
                        children: [
                          Text(
                            selectedTimeframe,
                            style: const TextStyle(color: AppColors.primaryPink, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.primaryPink),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: _openTimeframeSelector,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: const Icon(Icons.tune, size: 14, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal DSP filter pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(dspTabs.length, (index) {
                final isSelected = selectedDspIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedDspIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryPink.withValues(alpha: 0.15) : AppColors.cardSurfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryPink : AppColors.cardBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (index == 1)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(Icons.graphic_eq, size: 12, color: Color(0xFF1DB954)),
                          )
                        else if (index == 2)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(Icons.music_note, size: 12, color: Colors.pinkAccent),
                          )
                        else if (index == 3)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(Icons.play_arrow, size: 12, color: Colors.redAccent),
                          ),
                        Text(
                          dspTabs[index],
                          style: TextStyle(
                            color: isSelected ? AppColors.primaryPink : AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Tooltip stats card preview
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardSurfaceElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorderGlowing),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${dspTabs[selectedDspIndex]} • $selectedTimeframe Window',
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const CircleAvatar(radius: 2.5, backgroundColor: AppColors.successGreen),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Text(
                            '\$${currentGrossRevenue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.primaryPink,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPink.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '+${(2.34 * (selectedDspIndex == 1 ? 1.4 : 1.0)).toStringAsFixed(2)}% vs last period',
                              style: const TextStyle(
                                color: AppColors.primaryPink,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Peak: \$${currentPeakRevenue.toStringAsFixed(0)}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                    ),
                    Text(
                      'Floor: \$${currentFloorRevenue.toStringAsFixed(0)}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Main Interactive Line Chart
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (labels.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: Color(0xFF1B1B26),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (value, meta) {
                        if (value > 999) {
                          return Text(
                            '\$${(value / 1000).toStringAsFixed(1)}k',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
                          );
                        }
                        return Text(
                          '\$${value.toStringAsFixed(0)}',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final int index = value.toInt();
                        if (index >= 0 && index < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              labels[index],
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 9,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Actual realized streaming revenue
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.primaryPink,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) => spot.x == (labels.length - 2).clamp(0, labels.length - 1),
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 5,
                        color: AppColors.primaryPink,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryPink.withValues(alpha: 0.35),
                          AppColors.primaryPink.withValues(alpha: 0.08),
                          AppColors.primaryPink.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  // AI Projected Baseline Floor (Dashed Line)
                  LineChartBarData(
                    spots: floors,
                    isCurved: true,
                    dashArray: [5, 5],
                    color: AppColors.textMuted,
                    barWidth: 1.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 350), // Smooth animated chart transitions
              curve: Curves.easeInOut,
            ),
          ),
          const SizedBox(height: 12),

          // Legend
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 14, height: 3, color: AppColors.primaryPink),
                  const SizedBox(width: 6),
                  Text(
                    '${dspTabs[selectedDspIndex]} Realized',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 2,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'AI Projected Floor',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
