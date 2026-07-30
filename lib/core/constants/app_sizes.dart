/// ComicVerse Sizing & Spacing System
/// Based on an 8dp grid — all values are multiples of 4 or 8
abstract final class AppSizes {
  // ── Spacing Scale ────────────────────────────────────────────────────────
  static const double sp2 = 2.0;
  static const double sp4 = 4.0;
  static const double sp6 = 6.0;
  static const double sp8 = 8.0;
  static const double sp10 = 10.0;
  static const double sp12 = 12.0;
  static const double sp16 = 16.0;
  static const double sp20 = 20.0;
  static const double sp24 = 24.0;
  static const double sp32 = 32.0;
  static const double sp40 = 40.0;
  static const double sp48 = 48.0;
  static const double sp56 = 56.0;
  static const double sp64 = 64.0;
  static const double sp80 = 80.0;
  static const double sp96 = 96.0;

  // ── Border Radius ─────────────────────────────────────────────────────────
  static const double radiusXs = 6.0;
  static const double radiusSm = 10.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 18.0;
  static const double radiusXl = 24.0;
  static const double radius2xl = 32.0;
  static const double radiusFull = 999.0;

  // ── Icon Sizes ────────────────────────────────────────────────────────────
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double icon2xl = 48.0;

  // ── Touch Targets (Android minimum 48dp) ────────────────────────────────
  static const double touchTarget = 48.0;

  // ── Page Padding ─────────────────────────────────────────────────────────
  static const double pagePaddingH = 20.0;
  static const double pagePaddingV = 16.0;

  // ── Comic Card Dimensions ─────────────────────────────────────────────────
  /// Portrait comic card (standard manga/comics ratio ~2:3)
  static const double cardWidth = 130.0;
  static const double cardHeight = 195.0;

  /// Large featured card
  static const double featuredCardHeight = 340.0;

  /// Cover aspect ratio (width / height)
  static const double coverAspectRatio = 2 / 3;

  // ── Carousel ──────────────────────────────────────────────────────────────
  static const double heroCarouselHeight = 300.0;
  static const double carouselIndicatorSize = 8.0;

  // ── Bottom Navigation ─────────────────────────────────────────────────────
  static const double bottomNavHeight = 72.0;

  // ── App Bar ───────────────────────────────────────────────────────────────
  static const double appBarHeight = 56.0;

  // ── Section Gaps ─────────────────────────────────────────────────────────
  static const double sectionGap = 32.0;
  static const double itemGap = 12.0;

  // ── Reader ────────────────────────────────────────────────────────────────
  static const double readerControlsHeight = 80.0;

  // ── Blur Values ──────────────────────────────────────────────────────────
  static const double blurSm = 8.0;
  static const double blurMd = 16.0;
  static const double blurLg = 24.0;
  static const double blurXl = 40.0;

  // ── Elevation ─────────────────────────────────────────────────────────────
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;

  // ── Breakpoints ───────────────────────────────────────────────────────────
  static const double breakpointSm = 480.0;
  static const double breakpointMd = 768.0;
  static const double breakpointLg = 1024.0;

  // ── Durations ─────────────────────────────────────────────────────────────
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationSplash = Duration(milliseconds: 2500);
}
