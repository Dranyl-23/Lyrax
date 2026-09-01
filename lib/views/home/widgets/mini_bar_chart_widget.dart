import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MiniBarChartWidget extends StatelessWidget {
  final List<double> values;
  final Color color;
  final double height;

  const MiniBarChartWidget({
    super.key,
    required this.values,
    this.color = AppColors.primaryPink,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    final double maxVal = values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.map((val) {
          final double ratio = maxVal == 0 ? 0.2 : (val / maxVal).clamp(0.15, 1.0);
          return Container(
            width: 3.5,
            height: height * ratio,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 3,
                  spreadRadius: 0.5,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
