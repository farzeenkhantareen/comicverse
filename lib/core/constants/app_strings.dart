/// ComicVerse App-Wide String Constants
abstract final class AppStrings {
  // ── App Identity ─────────────────────────────────────────────────────────
  static const String appName = 'ComicVerse';
  static const String appTagline = 'Worlds Without Limits';
  static const String appVersion = '1.0.0';

  // ── Navigation Labels ─────────────────────────────────────────────────────
  static const String navHome = 'Home';
  static const String navLibrary = 'Library';
  static const String navSearch = 'Discover';
  static const String navSettings = 'Settings';

  // ── Home Screen ───────────────────────────────────────────────────────────
  static const String sectionFeatured = 'Featured';
  static const String sectionTrending = 'Trending Now';
  static const String sectionRecentlyAdded = 'Recently Added';
  static const String sectionEditorsChoice = "Editor's Choice";
  static const String sectionAiOriginals = 'AI Originals';
  static const String sectionContinueReading = 'Continue Reading';
  static const String sectionCategories = 'Browse Categories';
  static const String sectionPublicDomain = 'Public Domain Classics';

  // ── Library ───────────────────────────────────────────────────────────────
  static const String libraryFavorites = 'Favorites';
  static const String libraryHistory = 'History';
  static const String libraryDownloads = 'Downloads';
  static const String libraryCollections = 'Collections';

  // ── Reader ────────────────────────────────────────────────────────────────
  static const String readerChapters = 'Chapters';
  static const String readerBookmark = 'Bookmark';
  static const String readerSettings = 'Reader Settings';

  // ── Settings ──────────────────────────────────────────────────────────────
  static const String settingsAppearance = 'Appearance';
  static const String settingsReading = 'Reading';
  static const String settingsStorage = 'Storage & Cache';
  static const String settingsAbout = 'About';
  static const String settingsDarkMode = 'Dark Mode';
  static const String settingsLightMode = 'Light Mode';
  static const String settingsSystemTheme = 'System Default';

  // ── Onboarding ────────────────────────────────────────────────────────────
  static const String onboarding1Title = 'Discover Worlds';
  static const String onboarding1Subtitle =
      'Explore thousands of comics and manga — from timeless classics to cutting-edge AI originals.';
  static const String onboarding2Title = 'Read Anywhere';
  static const String onboarding2Subtitle =
      'Enjoy a seamless reading experience, fully offline — no internet required for your library.';
  static const String onboarding3Title = 'Your Universe';
  static const String onboarding3Subtitle =
      'Organize your favorites, track your progress, and build your personal comic collection.';

  static const String getStarted = 'Get Started';
  static const String skip = 'Skip';
  static const String next = 'Next';

  // ── Search ────────────────────────────────────────────────────────────────
  static const String searchHint = 'Search comics, manga, authors…';
  static const String searchEmpty = 'No results found';
  static const String searchEmptySubtitle = 'Try different keywords or browse by category';

  // ── Empty States ──────────────────────────────────────────────────────────
  static const String emptyFavorites = 'No favorites yet';
  static const String emptyFavoritesSubtitle = 'Tap the heart on any comic to save it here';
  static const String emptyHistory = 'No reading history';
  static const String emptyHistorySubtitle = 'Comics you read will appear here';

  // ── Errors ────────────────────────────────────────────────────────────────
  static const String errorGeneric = 'Something went wrong';
  static const String errorRetry = 'Retry';

  // ── Categories ────────────────────────────────────────────────────────────
  static const List<String> allCategories = [
    'Action', 'Adventure', 'Fantasy', 'Comedy', 'Drama',
    'Romance', 'Mystery', 'Sci-Fi', 'Historical', 'Slice of Life',
    'Sports', 'Military', 'Magic', 'Supernatural', 'Psychological',
    'Horror', 'Thriller', 'Crime', 'Detective', 'Cooking',
    'Medical', 'Isekai', 'Martial Arts', 'Kids', 'Family',
    'Educational', 'Classic Comics', 'Graphic Novels', 'Web Comics',
    'AI Originals', 'Public Domain', 'Creative Commons',
  ];

  // ── Reading Directions ────────────────────────────────────────────────────
  static const String directionLTR = 'Left to Right';
  static const String directionRTL = 'Right to Left (Manga)';
  static const String directionVertical = 'Vertical Scroll';

  // ── Legal ─────────────────────────────────────────────────────────────────
  static const String privacyPolicyUrl = 'https://comicverse.app/privacy';
  static const String aboutDescription =
      'ComicVerse is an offline comic reader featuring legally licensed public domain content and original AI-generated stories. No data is collected. No internet required.';
}
