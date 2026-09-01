import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CircularGaugeWidget extends StatelessWidget {
  final double percentage; // 0.0 to 100.0
  final double size;
  final Color activeColor;
  final Color trackColor;

  const CircularGaugeWidget({
    super.key,
    required this.percentage,
    this.size = 64,
    this.activeColor = AppColors.primaryPink,
    this.trackColor = const Color(0xFF22222E),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CircularGaugePainter(
          percentage: percentage,
          activeColor: activeColor,
          trackColor: trackColor,
        ),
        child: Center(
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularGaugePainter extends CustomPainter {
  final double percentage;
  final Color activeColor;
  final Color trackColor;

  _CircularGaugePainter({
    required this.percentage,
    required this.activeColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 5;
    const strokeWidth = 7.0;

    // Draw background circle track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // Draw active arc with neon glow
    final sweepAngle = (percentage / 100) * 2 * pi;
    final activePaint = Paint()
      ..shader = const SweepGradient(
        startAngle: 0,
        endAngle: 2 * pi,
        colors: [
          Color(0xFFFF62A5),
          AppColors.primaryPink,
          Color(0xFFC0156E),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Rotate by -pi/2 so it starts at the top
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-pi / 2);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      sweepAngle,
      false,
      activePaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircularGaugePainter oldDelegate) =>
      oldDelegate.percentage != percentage;
}
