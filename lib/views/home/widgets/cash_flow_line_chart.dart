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

  // 7-day streaming data points (normalized or in USD)
  final List<FlSpot> actualStreamSpots = const [
    FlSpot(0, 1540),
    FlSpot(1, 1620),
    FlSpot(2, 1580),
    FlSpot(3, 1790),
    FlSpot(4, 1920),
    FlSpot(5, 1842),
    FlSpot(6, 1980),
  ];

  // AI Underwritten Floor Baseline
  final List<FlSpot> aiProjectedFloorSpots = const [
    FlSpot(0, 1420),
    FlSpot(1, 1450),
    FlSpot(2, 1470),
    FlSpot(3, 1500),
    FlSpot(4, 1530),
    FlSpot(5, 1560),
    FlSpot(6, 1580),
  ];

  final List<String> days = ['Sep 6', 'Sep 7', 'Sep 8', 'Sep 9', 'Sep 10', 'Sep 11', 'Sep 12'];

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          '7D',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Icon(Icons.tune, size: 14, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal DSP filter pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                    child: Text(
                      dspTabs[index],
                      style: TextStyle(
                        color: isSelected ? AppColors.primaryPink : AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Tooltip stats card preview (like reference screen)
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
                      const Text(
                        'Sep 12, 2026 14:00 UTC',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          const Text(
                            '\$1,842.50',
                            style: TextStyle(
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
                            child: const Text(
                              '+2.34% vs last 24h',
                              style: TextStyle(
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'High: \$2,104.00',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
                    ),
                    Text(
                      'Floor: \$1,420.00',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 10),
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
                maxX: 6,
                minY: 1300,
                maxY: 2200,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 300,
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
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${(value / 1000).toStringAsFixed(1)}k',
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
                        if (index >= 0 && index < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[index],
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
                  // Actual realized streaming revenue (Pink glowing line)
                  LineChartBarData(
                    spots: actualStreamSpots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.primaryPink,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) => spot.x == 5, // Highlight current day
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
                    spots: aiProjectedFloorSpots,
                    isCurved: true,
                    dashArray: [5, 5],
                    color: AppColors.textMuted,
                    barWidth: 1.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
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
                  const Text(
                    'Verified DSP Revenue',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
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
