import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../router/app_router.dart';
import '../../shared/models/comic.dart';
import '../../shared/repositories/comic_repository.dart';
import '../../shared/services/hive_service.dart';
import '../../shared/services/mangadex_service.dart';
import '../../shared/services/openverse_service.dart';
import '../../shared/services/comicvine_service.dart';

// ── Shared Preferences ───────────────────────────────────────────────────────

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize before use');
});

// ── Theme ────────────────────────────────────────────────────────────────────

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadTheme();
  }

  static const _key = 'theme_mode';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key) ?? 'dark';
    state = _fromString(saved);
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _toString(mode));
  }

  ThemeMode _fromString(String s) {
    switch (s) {
      case 'light': return ThemeMode.light;
      case 'system': return ThemeMode.system;
      default: return ThemeMode.dark;
    }
  }

  String _toString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light: return 'light';
      case ThemeMode.system: return 'system';
      default: return 'dark';
    }
  }
}

// ── Content Repository ────────────────────────────────────────────────────────

final comicRepositoryProvider = Provider<ComicRepository>((ref) {
  return LocalComicRepository();
});

// ── Comic Catalog ─────────────────────────────────────────────────────────────

final allComicsProvider = FutureProvider<List<Comic>>((ref) async {
  final repo = ref.watch(comicRepositoryProvider);
  return repo.getAllComics();
});

final trendingComicsProvider = FutureProvider<List<Comic>>((ref) async {
  final all = await ref.watch(allComicsProvider.future);
  final trending = all.where((c) => c.isTrending).toList();
  trending.sort((a, b) => b.rating.compareTo(a.rating));
  return trending.take(10).toList();
});

final editorsChoiceProvider = FutureProvider<List<Comic>>((ref) async {
  final all = await ref.watch(allComicsProvider.future);
  return all.where((c) => c.isEditorsChoice).take(6).toList();
});

final aiOriginalsProvider = FutureProvider<List<Comic>>((ref) async {
  final all = await ref.watch(allComicsProvider.future);
  return all.where((c) => c.license == 'AI-Original').toList();
});

final publicDomainProvider = FutureProvider<List<Comic>>((ref) async {
  final all = await ref.watch(allComicsProvider.future);
  return all.where((c) => c.license == 'Public Domain').toList();
});

final featuredComicsProvider = FutureProvider<List<Comic>>((ref) async {
  final all = await ref.watch(allComicsProvider.future);
  return all.where((c) => c.isFeatured).take(5).toList();
});

// ── Single Comic ──────────────────────────────────────────────────────────────

final comicByIdProvider = FutureProvider.family<Comic?, String>((ref, id) async {
  if (id.startsWith('md_')) {
    final cleanId = id.substring(3);
    final mdService = MangaDexService();
    // Query search to populate basic info
    final searchList = await mdService.searchManga('');
    final Comic? matched = searchList.firstWhere(
      (c) => c.id == id,
      orElse: () => Comic(
        id: id,
        title: 'MangaDex Title',
        author: 'MangaDex Artist',
        artist: 'MangaDex Artist',
        description: '',
        coverAsset: '',
        genres: const ['MangaDex'],
        tags: const [],
        language: 'en',
        license: 'MangaDex License',
        year: 2026,
        rating: 4.5,
        chapters: const [],
      ),
    );

    if (matched != null) {
      final chapters = await mdService.getChapters(cleanId);
      return Comic(
        id: matched.id,
        title: matched.title,
        author: matched.author,
        artist: matched.artist,
        description: matched.description,
        coverAsset: matched.coverAsset,
        genres: matched.genres,
        tags: matched.tags,
        language: matched.language,
        license: matched.license,
        year: matched.year,
        rating: matched.rating,
        chapters: chapters,
      );
    }
  }

  if (id.startsWith('ov_')) {
    final cleanId = id.substring(3);
    final ovService = OpenverseService();
    final searchList = await ovService.searchImages('');
    final Comic? matched = searchList.firstWhere(
      (c) => c.id == id,
      orElse: () => Comic(
        id: id,
        title: 'Openverse Media',
        author: 'Openverse Creator',
        artist: 'Openverse Creator',
        description: '',
        coverAsset: '',
        genres: const ['Openverse'],
        tags: const [],
        language: 'en',
        license: 'CC',
        year: 2026,
        rating: 4.8,
        chapters: [
          Chapter(
            id: 'ov_ch_$cleanId',
            title: 'Image View',
            chapterNumber: 1,
            pages: const [],
          ),
        ],
      ),
    );
    return matched;
  }

  if (id.startsWith('cv_')) {
    final cleanId = id.substring(3);
    final cvService = ComicVineService();
    return await cvService.getVolumeDetails(cleanId);
  }

  final repo = ref.watch(comicRepositoryProvider);
  return repo.getComicById(id);
});

// ── Search ────────────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedGenresProvider = StateProvider<List<String>>((ref) => []);
final searchSortProvider = StateProvider<SearchSort>((ref) => SearchSort.popularity);

enum SearchSort { popularity, newest, alphabetical, rating }

final searchResultsProvider = FutureProvider<List<Comic>>((ref) async {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final genres = ref.watch(selectedGenresProvider);
  final sort = ref.watch(searchSortProvider);
  final all = await ref.watch(allComicsProvider.future);

  var results = all.where((comic) {
    final matchesQuery = query.isEmpty ||
        comic.title.toLowerCase().contains(query) ||
        comic.author.toLowerCase().contains(query) ||
        comic.description.toLowerCase().contains(query) ||
        comic.tags.any((t) => t.toLowerCase().contains(query));
    final matchesGenre = genres.isEmpty ||
        genres.any((g) => comic.genres.contains(g));
    return matchesQuery && matchesGenre;
  }).toList();

  // If online, also query MangaDex for a rich dynamic catalog
  if (query.isNotEmpty) {
    try {
      final mdService = MangaDexService();
      final mdResults = await mdService.searchManga(query);
      results.addAll(mdResults);
    } catch (_) {}

    try {
      final ovService = OpenverseService();
      final ovResults = await ovService.searchImages(query);
      results.addAll(ovResults);
    } catch (_) {}

    try {
      final cvService = ComicVineService();
      final cvResults = await cvService.searchVolumes(query);
      results.addAll(cvResults);
    } catch (_) {}
  }

  switch (sort) {
    case SearchSort.popularity:
      results.sort((a, b) => b.rating.compareTo(a.rating));
    case SearchSort.newest:
      results.sort((a, b) => b.year.compareTo(a.year));
    case SearchSort.alphabetical:
      results.sort((a, b) => a.title.compareTo(b.title));
    case SearchSort.rating:
      results.sort((a, b) => b.rating.compareTo(a.rating));
  }

  return results;
});

// ── Library / Favorites / History ─────────────────────────────────────────────

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList('favorites') ?? [];
  }

  Future<void> toggle(String comicId) async {
    if (state.contains(comicId)) {
      state = state.where((id) => id != comicId).toList();
    } else {
      state = [...state, comicId];
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', state);
  }

  bool isFavorite(String comicId) => state.contains(comicId);
}

final favoriteComicsProvider = FutureProvider<List<Comic>>((ref) async {
  final ids = ref.watch(favoritesProvider);
  if (ids.isEmpty) return [];
  final all = await ref.watch(allComicsProvider.future);
  return all.where((c) => ids.contains(c.id)).toList();
});

// ── Reading Progress ──────────────────────────────────────────────────────────

final readingHistoryProvider = StateNotifierProvider<ReadingHistoryNotifier, Map<String, ReadingProgress>>((ref) {
  return ReadingHistoryNotifier();
});

class ReadingProgress {
  final String comicId;
  final int chapterIndex;
  final int pageIndex;
  final DateTime lastRead;

  const ReadingProgress({
    required this.comicId,
    required this.chapterIndex,
    required this.pageIndex,
    required this.lastRead,
  });
}

class ReadingHistoryNotifier extends StateNotifier<Map<String, ReadingProgress>> {
  ReadingHistoryNotifier() : super({}) {
    _load();
  }

  static const _key = 'reading_progress';

  Future<void> _load() async {
    // Load from Hive box
    final box = HiveService.readingProgressBox;
    final Map<String, ReadingProgress> loaded = {};
    for (final key in box.keys) {
      final data = box.get(key);
      if (data is Map) {
        loaded[key.toString()] = ReadingProgress(
          comicId: key.toString(),
          chapterIndex: data['chapter'] as int? ?? 0,
          pageIndex: data['page'] as int? ?? 0,
          lastRead: DateTime.tryParse(data['lastRead'] as String? ?? '') ?? DateTime.now(),
        );
      }
    }
    state = loaded;
  }

  Future<void> updateProgress(String comicId, int chapter, int page) async {
    final progress = ReadingProgress(
      comicId: comicId,
      chapterIndex: chapter,
      pageIndex: page,
      lastRead: DateTime.now(),
    );
    state = {...state, comicId: progress};
    // Persist to Hive
    await HiveService.readingProgressBox.put(comicId, {
      'chapter': chapter,
      'page': page,
      'lastRead': progress.lastRead.toIso8601String(),
    });
  }

  ReadingProgress? getProgress(String comicId) => state[comicId];

  List<ReadingProgress> get recentHistory {
    final entries = state.values.toList();
    entries.sort((a, b) => b.lastRead.compareTo(a.lastRead));
    return entries.take(20).toList();
  }
}

// ── Settings ──────────────────────────────────────────────────────────────────

final readingDirectionProvider = StateNotifierProvider<ReadingDirectionNotifier, ReadingDirection>((ref) {
  return ReadingDirectionNotifier();
});

class ReadingDirectionNotifier extends StateNotifier<ReadingDirection> {
  ReadingDirectionNotifier() : super(ReadingDirection.ltr) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('reading_direction') ?? 'ltr';
    state = ReadingDirection.values.firstWhere((e) => e.name == saved, orElse: () => ReadingDirection.ltr);
  }

  Future<void> set(ReadingDirection dir) async {
    state = dir;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reading_direction', dir.name);
  }
}

final readerModeProvider = StateProvider<ReaderMode>((ref) => ReaderMode.normal);

enum ReaderMode { normal, night, sepia }

final fontSizeScaleProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  return FontSizeNotifier();
});

class FontSizeNotifier extends StateNotifier<double> {
  FontSizeNotifier() : super(1.0) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble('font_scale') ?? 1.0;
  }

  Future<void> set(double scale) async {
    state = scale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_scale', scale);
  }
}

// ── Onboarding ────────────────────────────────────────────────────────────────

final hasSeenOnboardingProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_done') ?? false;
});

Future<void> markOnboardingDone() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboarding_done', true);
}
