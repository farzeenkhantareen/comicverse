import 'package:flutter/material.dart';

/// ComicVerse Color Palette
/// Primary: Deep Purple | Secondary: Electric Blue | Accent: Cyan
/// Background: #0E1117 | Cards: #1A1F2E
abstract final class AppColors {
  // ── Brand Colors ────────────────────────────────────────────────────────
  static const Color primaryPurple = Color(0xFF7B2FBE);
  static const Color primaryPurpleLight = Color(0xFFB57BEE);
  static const Color primaryPurpleDark = Color(0xFF4A1680);
  static const Color primaryPurpleGlow = Color(0xFF9C3DDB);

  static const Color electricBlue = Color(0xFF2979FF);
  static const Color electricBlueLight = Color(0xFF82B1FF);
  static const Color electricBlueDark = Color(0xFF1651C5);

  static const Color cyan = Color(0xFF00BCD4);
  static const Color cyanLight = Color(0xFF62EFFF);
  static const Color cyanDark = Color(0xFF008BA3);

  // ── Backgrounds ─────────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0E1117);
  static const Color cardDark = Color(0xFF1A1F2E);
  static const Color surfaceVariant = Color(0xFF242938);
  static const Color surfaceElevated = Color(0xFF2D3348);

  // ── Text ────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9BA3BC);
  static const Color textMuted = Color(0xFF5C6480);
  static const Color textDisabled = Color(0xFF3A3F55);

  // ── Borders ─────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF3A3F55);
  static const Color outlineVariant = Color(0xFF2A2F45);

  // ── Status Colors ────────────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFA5D6A7);
  static const Color warning = Color(0xFFFFB300);
  static const Color warningLight = Color(0xFFFFE082);
  static const Color error = Color(0xFFEF5350);
  static const Color errorLight = Color(0xFFEF9A9A);

  // ── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A1680), Color(0xFF1651C5)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryPurpleDark],
  );

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricBlue, electricBlueDark],
  );

  static const LinearGradient cyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cyan, cyanDark],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC0E1117)],
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      Color(0xFF1A1F2E),
      Color(0xFF242938),
      Color(0xFF1A1F2E),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ── Glass Effect ────────────────────────────────────────────────────────
  static Color glassBackground = Colors.white.withOpacity(0.05);
  static Color glassBorder = Colors.white.withOpacity(0.1);

  // ── Category Colors ──────────────────────────────────────────────────────
  static const List<Color> categoryColors = [
    Color(0xFF7B2FBE), // Action — Purple
    Color(0xFF2979FF), // Adventure — Blue
    Color(0xFFFF6B35), // Fantasy — Orange
    Color(0xFFFFD700), // Comedy — Gold
    Color(0xFFE91E63), // Drama — Pink
    Color(0xFFFF4081), // Romance — Hot Pink
    Color(0xFF26C6DA), // Mystery — Teal
    Color(0xFF00BCD4), // Sci-Fi — Cyan
    Color(0xFF8BC34A), // Historical — Green
    Color(0xFFFF7043), // Slice of Life — Deep Orange
    Color(0xFF42A5F5), // Sports — Light Blue
    Color(0xFF78909C), // Military — Blue Grey
    Color(0xFFAB47BC), // Magic — Purple
    Color(0xFF5C6BC0), // Supernatural — Indigo
    Color(0xFFEC407A), // Psychological — Pink
    Color(0xFF212121), // Horror — Near Black
  ];

  // ── Rating Stars ─────────────────────────────────────────────────────────
  static const Color starFilled = Color(0xFFFFB300);
  static const Color starEmpty = Color(0xFF3A3F55);
}
