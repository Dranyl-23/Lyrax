import 'package:flutter/material.dart';

class AppColors {
  // Deep Obsidian Dark Base
  static const Color background = Color(0xFF09090D);
  static const Color cardSurface = Color(0xFF13131A);
  static const Color cardSurfaceElevated = Color(0xFF181822);
  static const Color cardBorder = Color(0xFF22222E);
  static const Color cardBorderGlowing = Color(0x33FF2E93);

  // Neon Cyber Pink Accents (H.E.R. DAO & Synthwave / Music)
  static const Color primaryPink = Color(0xFFFF2E93);
  static const Color primaryPinkGlow = Color(0x66FF2E93);
  static const Color vibrantPink = Color(0xFFFF419E);
  static const Color softPink = Color(0xFFFF7EB3);
  static const Color deepMagenta = Color(0xFFC0156E);

  // Status & Utility Colors
  static const Color successGreen = Color(0xFF00E676);
  static const Color warningOrange = Color(0xFFFF9100);
  static const Color infoBlue = Color(0xFF00B0FF);

  // Typography
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9EAF);
  static const Color textMuted = Color(0xFF656578);

  // Gradients
  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF2E93), Color(0xFFFF62A5)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF161620), Color(0xFF111117)],
  );

  static const LinearGradient chartAreaGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x4DFF2E93),
      Color(0x1AFF2E93),
      Color(0x00FF2E93),
    ],
  );
}
