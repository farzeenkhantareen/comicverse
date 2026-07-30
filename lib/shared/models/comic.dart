import 'package:equatable/equatable.dart';

/// Core Comic model — represents a single comic title with all metadata.
/// Designed for extensibility: add fields without breaking existing code.
class Comic extends Equatable {
  const Comic({
    required this.id,
    required this.title,
    required this.author,
    required this.artist,
    required this.description,
    required this.coverAsset,
    required this.genres,
    required this.tags,
    required this.language,
    required this.license,
    required this.year,
    required this.rating,
    required this.chapters,
    this.publisher,
    this.readingDirection = ReadingDirection.ltr,
    this.isTrending = false,
    this.isFeatured = false,
    this.isEditorsChoice = false,
    this.totalPages = 0,
    this.accentColor,
  });

  final String id;
  final String title;
  final String author;
  final String artist;
  final String? publisher;
  final String description;

  /// Path relative to assets/ — e.g. "covers/my_cover.png"
  final String coverAsset;

  final List<String> genres;
  final List<String> tags;
  final String language;

  /// License string — e.g. "Public Domain", "CC BY 4.0", "AI-Original"
  final String license;

  final int year;
  final double rating;
  final List<Chapter> chapters;
  final ReadingDirection readingDirection;

  final bool isTrending;
  final bool isFeatured;
  final bool isEditorsChoice;
  final int totalPages;

  /// Optional accent color hex for theming the reader/card
  final String? accentColor;

  // ── Computed Properties ─────────────────────────────────────────────────

  String get primaryGenre => genres.isNotEmpty ? genres.first : 'Unknown';

  String get chapterCount => chapters.length == 1
      ? '1 Chapter'
      : '${chapters.length} Chapters';

  String get ratingFormatted => rating.toStringAsFixed(1);

  bool get isComplete => chapters.every((c) => c.pageCount > 0);

  bool get isAiOriginal => license == 'AI-Original';
  bool get isPublicDomain => license == 'Public Domain';
  bool get isCreativeCommons => license.startsWith('CC');

  @override
  List<Object?> get props => [id, title, author, license];
}

/// Chapter within a comic — points to page asset paths
class Chapter extends Equatable {
  const Chapter({
    required this.id,
    required this.title,
    required this.chapterNumber,
    required this.pages,
    this.synopsis,
    this.releaseDate,
  });

  final String id;
  final String title;
  final int chapterNumber;

  /// List of asset paths for each page — e.g. ["comics/my_comic/ch1/page_001.png"]
  final List<String> pages;

  final String? synopsis;
  final DateTime? releaseDate;

  int get pageCount => pages.length;

  String get displayTitle => 'Chapter $chapterNumber: $title';

  @override
  List<Object?> get props => [id, chapterNumber];
}

enum ReadingDirection {
  /// Standard Western left-to-right
  ltr,

  /// Traditional manga right-to-left
  rtl,

  /// Webtoon vertical scroll
  vertical,
}
