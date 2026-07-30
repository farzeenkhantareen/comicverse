import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/comic.dart';

/// Abstract repository interface — swap implementations without touching UI
abstract class ComicRepository {
  Future<List<Comic>> getAllComics();
  Future<Comic?> getComicById(String id);
  Future<List<Comic>> getComicsByGenre(String genre);
  Future<List<Comic>> searchComics(String query);
}

/// Local implementation that reads from bundled JSON catalog
class LocalComicRepository implements ComicRepository {
  List<Comic>? _cache;

  @override
  Future<List<Comic>> getAllComics() async {
    if (_cache != null) return _cache!;
    _cache = await ContentIndexer.loadCatalog();
    return _cache!;
  }

  @override
  Future<Comic?> getComicById(String id) async {
    final all = await getAllComics();
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Comic>> getComicsByGenre(String genre) async {
    final all = await getAllComics();
    return all.where((c) => c.genres.contains(genre)).toList();
  }

  @override
  Future<List<Comic>> searchComics(String query) async {
    final all = await getAllComics();
    final q = query.toLowerCase();
    return all.where((c) =>
      c.title.toLowerCase().contains(q) ||
      c.author.toLowerCase().contains(q) ||
      c.tags.any((t) => t.toLowerCase().contains(q))
    ).toList();
  }
}

/// Parses the JSON catalog into Comic objects
class ContentIndexer {
  static Future<List<Comic>> loadCatalog() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/comics/metadata/catalog.json');
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final items = data['comics'] as List<dynamic>;
      return items.map((e) => _parseComic(e as Map<String, dynamic>)).toList();
    } catch (e) {
      // Return empty list gracefully if catalog fails to load
      return [];
    }
  }

  static Comic _parseComic(Map<String, dynamic> json) {
    final chaptersJson = json['chapters'] as List<dynamic>? ?? [];
    return Comic(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      artist: json['artist'] as String? ?? json['author'] as String,
      publisher: json['publisher'] as String?,
      description: json['description'] as String,
      coverAsset: json['cover'] as String,
      genres: List<String>.from(json['genres'] as List? ?? []),
      tags: List<String>.from(json['tags'] as List? ?? []),
      language: json['language'] as String? ?? 'English',
      license: json['license'] as String,
      year: json['year'] as int? ?? 2024,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
      chapters: chaptersJson.map((c) => _parseChapter(c as Map<String, dynamic>)).toList(),
      readingDirection: _parseDirection(json['reading_direction'] as String?),
      isTrending: json['trending'] as bool? ?? false,
      isFeatured: json['featured'] as bool? ?? false,
      isEditorsChoice: json['editors_choice'] as bool? ?? false,
      totalPages: json['total_pages'] as int? ?? 0,
      accentColor: json['accent_color'] as String?,
    );
  }

  static Chapter _parseChapter(Map<String, dynamic> json) {
    final pagesJson = json['pages'] as List<dynamic>? ?? [];
    return Chapter(
      id: json['id'] as String,
      title: json['title'] as String,
      chapterNumber: json['number'] as int? ?? 1,
      pages: List<String>.from(pagesJson),
      synopsis: json['synopsis'] as String?,
    );
  }

  static ReadingDirection _parseDirection(String? dir) {
    switch (dir) {
      case 'rtl': return ReadingDirection.rtl;
      case 'vertical': return ReadingDirection.vertical;
      default: return ReadingDirection.ltr;
    }
  }
}
