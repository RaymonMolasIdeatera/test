// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryTeal = Color(0xFF30D5D2);
  static const Color darkTeal = Color(0xFF1A7A78);
  static const Color lightTeal = Color(0xFF5DDBDA);
  
  // Alias para compatibilidad
  static const Color primary = primaryTeal;
  static const Color secondary = accent;

  // Background Colors
  static const Color background = Color(0xFF000000);
  static const Color darkBackground = Color(0xFF001E2B);
  static const Color cardBackground = Color(0xFF0A1A2A);
  static const Color surfaceColor = Color(0xFF1A1A1A);
  
  // Alias para compatibilidad
  static const Color surface = surfaceColor;

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF666666);
  static const Color textDisabled = Color(0xFF444444);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF2196F3);

  // Accent Colors
  static const Color accent = Color(0xFFFF6B35);
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);

  // Border Colors
  static const Color border = Color(0xFF333333);
  static const Color borderLight = Color(0xFF555555);
  static const Color borderDark = Color(0xFF222222);

  // Transparent Colors
  static const Color barrier = Color(0x80000000);
  static const Color overlay = Color(0x40000000);
  static const Color shimmer = Color(0x20FFFFFF);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryTeal, darkTeal],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, darkBackground],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBackground, surfaceColor],
  );
}