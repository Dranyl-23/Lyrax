import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/catalog_position.dart';
import 'sparkline_widget.dart';

class CatalogPositionTile extends StatelessWidget {
  final CatalogPosition position;
  final VoidCallback? onTap;

  const CatalogPositionTile({
    super.key,
    required this.position,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primaryPink.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // DSP / Music Icon Circle
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardSurfaceElevated,
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Center(
                child: Icon(
                  position.dsp == 'Spotify'
                      ? Icons.graphic_eq
                      : (position.dsp == 'Apple Music' ? Icons.music_note : Icons.play_arrow),
                  size: 16,
                  color: AppColors.primaryPink,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Symbol & Title
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    position.symbol,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    position.title,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 9,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Exposure & mini sparkline
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${(position.exposureUsd / 1000).toStringAsFixed(1)}K',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SparklineWidget(
                    data: position.sparkline,
                    height: 12,
                    width: 36,
                    color: AppColors.primaryPink,
                  ),
                ],
              ),
            ),

            // Ownership % with mini horizontal pink bar
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${position.ownershipPercent.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: position.ownershipPercent / 100,
                      backgroundColor: AppColors.cardBorder,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPink),
                      minHeight: 2.5,
                    ),
                  ),
                ],
              ),
            ),

            // Daily Yield / ROI
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${position.dailyPayoutUsd.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: AppColors.primaryPink,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.arrow_upward, size: 8, color: AppColors.primaryPink),
                      Text(
                        '${position.roiPercent.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: AppColors.primaryPink,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Settlement / Maturity
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      position.maturityDate,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 8.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 12, color: AppColors.textMuted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
