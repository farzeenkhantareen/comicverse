import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// ComicVerse Material 3 Theme System
/// Dark-first design with deep purple, electric blue, and cyan accent palette
class AppTheme {
  AppTheme._();

  // ── Dark Theme (Primary) ────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primaryPurple,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryPurpleDark,
      onPrimaryContainer: AppColors.primaryPurpleLight,
      secondary: AppColors.electricBlue,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.electricBlueDark,
      onSecondaryContainer: AppColors.electricBlueLight,
      tertiary: AppColors.cyan,
      onTertiary: Colors.black,
      tertiaryContainer: AppColors.cyanDark,
      onTertiaryContainer: AppColors.cyanLight,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.cardDark,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black87,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.backgroundDark,
      inversePrimary: AppColors.primaryPurpleDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _buildTextTheme(Colors.white),
      appBarTheme: _buildAppBarTheme(colorScheme),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: _buildBottomNavTheme(colorScheme),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      iconTheme: IconThemeData(color: AppColors.textPrimary, size: 24),
      dividerTheme: DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceVariant,
        contentTextStyle: GoogleFonts.outfit(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryPurple,
        thumbColor: AppColors.primaryPurple,
        inactiveTrackColor: AppColors.outlineVariant,
        overlayColor: AppColors.primaryPurple.withOpacity(0.2),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primaryPurple;
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryPurple.withOpacity(0.5);
          }
          return AppColors.outlineVariant;
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primaryPurple,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primaryPurple,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // ── Light Theme ─────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primaryPurple,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFEADDFF),
      onPrimaryContainer: const Color(0xFF21005D),
      secondary: AppColors.electricBlue,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFDDE8FF),
      onSecondaryContainer: const Color(0xFF001849),
      tertiary: const Color(0xFF006A6A),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFF9FF0F0),
      onTertiaryContainer: const Color(0xFF002020),
      error: AppColors.error,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF1C1B1F),
      surfaceContainerHighest: const Color(0xFFE7E0EC),
      onSurfaceVariant: const Color(0xFF49454F),
      outline: const Color(0xFF79747E),
      outlineVariant: const Color(0xFFCAC4D0),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF6F0FF),
      textTheme: _buildTextTheme(const Color(0xFF1C1B1F)),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF6F0FF),
        foregroundColor: const Color(0xFF1C1B1F),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: const Color(0xFF1C1B1F),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // ── Text Theme ──────────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(Color baseColor) {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 57, fontWeight: FontWeight.w800, color: baseColor, letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 45, fontWeight: FontWeight.w700, color: baseColor,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 36, fontWeight: FontWeight.w700, color: baseColor,
      ),
      headlineLarge: GoogleFonts.outfit(
        fontSize: 32, fontWeight: FontWeight.w700, color: baseColor,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 28, fontWeight: FontWeight.w600, color: baseColor,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 24, fontWeight: FontWeight.w600, color: baseColor,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 22, fontWeight: FontWeight.w600, color: baseColor,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 16, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: 14, fontWeight: FontWeight.w500, color: baseColor, letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, color: baseColor, height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, color: baseColor, height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400, color: baseColor, height: 1.4,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 14, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: 12, fontWeight: FontWeight.w500, color: baseColor, letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: 11, fontWeight: FontWeight.w500, color: baseColor, letterSpacing: 0.5,
      ),
    );
  }

  // ── Component Themes ────────────────────────────────────────────────────
  static AppBarTheme _buildAppBarTheme(ColorScheme cs) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 24),
      actionsIconTheme: const IconThemeData(color: Colors.white, size: 24),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  static CardTheme _buildCardTheme(ColorScheme cs) {
    return CardTheme(
      color: AppColors.cardDark,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavTheme(ColorScheme cs) {
    return BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardDark,
      selectedItemColor: AppColors.primaryPurple,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500),
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(ColorScheme cs) {
    return NavigationBarThemeData(
      backgroundColor: AppColors.cardDark,
      indicatorColor: AppColors.primaryPurple.withOpacity(0.2),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: AppColors.primaryPurple, size: 24);
        }
        return IconThemeData(color: AppColors.textSecondary, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.outfit(
            color: AppColors.primaryPurple,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return GoogleFonts.outfit(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
      }),
    );
  }

  static ChipThemeData _buildChipTheme(ColorScheme cs) {
    return ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primaryPurple.withOpacity(0.3),
      labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.outlineVariant),
      ),
      selectedShadowColor: Colors.transparent,
      showCheckmark: false,
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(ColorScheme cs) {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      hintStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.outlineVariant, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primaryPurple, width: 2),
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme cs) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme cs) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryPurple,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}
