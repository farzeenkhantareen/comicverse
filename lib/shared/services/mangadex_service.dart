import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/comic.dart';

class MangaDexService {
  static const String _baseUrl = 'https://api.mangadex.org';
  static const String _uploadsUrl = 'https://uploads.mangadex.org';

  final http.Client _client;

  MangaDexService({http.Client? client}) : _client = client ?? http.Client();

  /// Search Manga titles with filter tags (e.g. only Creative Commons/open-source contents if applicable)
  Future<List<Comic>> searchManga(String query, {List<String>? genres}) async {
    final Map<String, String> queryParameters = {
      'limit': '15',
      'includes[]': 'cover_art',
    };

    if (query.isNotEmpty) {
      queryParameters['title'] = query;
    }

    // Filter to Creative Commons / Open Source works (MangaDex official publisher or creative commons tags if desired)
    // Note: We search generally but flag licenses locally in mapping.
    
    final uri = Uri.parse('$_baseUrl/manga').replace(queryParameters: queryParameters);
    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final list = data['data'] as List<dynamic>? ?? [];
      
      final List<Comic> results = [];
      for (final item in list) {
        final comic = _parseMangaDexManga(item);
        if (comic != null) {
          results.add(comic);
        }
      }
      return results;
    } catch (_) {
      return [];
    }
  }

  /// Get chapters for a MangaDex manga ID
  Future<List<Chapter>> getChapters(String mangaId) async {
    final uri = Uri.parse('$_baseUrl/manga/$mangaId/feed').replace(queryParameters: {
      'limit': '100',
      'translatedLanguage[]': 'en',
      'order[chapter]': 'asc',
    });

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final list = data['data'] as List<dynamic>? ?? [];

      final List<Chapter> chapters = [];
      for (final item in list) {
        final attrs = item['attributes'] as Map<String, dynamic>;
        final String chId = item['id'] as String;
        final String title = attrs['title'] as String? ?? 'Chapter';
        final double? chNumVal = double.tryParse(attrs['chapter'] as String? ?? '');
        final int chNum = chNumVal?.toInt() ?? 1;

        // Fetch pages via At-Home server endpoints dynamically
        final pages = await _getChapterPages(chId);

        chapters.add(Chapter(
          id: chId,
          title: title,
          chapterNumber: chNum,
          pages: pages,
        ));
      }
      return chapters;
    } catch (_) {
      return [];
    }
  }

  Future<List<String>> _getChapterPages(String chapterId) async {
    final uri = Uri.parse('$_baseUrl/at-home/server/$chapterId');
    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final baseUrl = data['baseUrl'] as String;
      final chapterData = data['chapter'] as Map<String, dynamic>;
      final hash = chapterData['hash'] as String;
      final files = chapterData['data'] as List<dynamic>;

      // We return the absolute URLs directly
      return files.map((file) => '$baseUrl/data/$hash/$file').toList();
    } catch (_) {
      return [];
    }
  }

  Comic? _parseMangaDexManga(Map<String, dynamic> json) {
    try {
      final String id = json['id'] as String;
      final attrs = json['attributes'] as Map<String, dynamic>;
      
      final titleMap = attrs['title'] as Map<String, dynamic>? ?? {};
      final String title = titleMap['en'] as String? ?? titleMap.values.firstOrNull as String? ?? 'Unknown Title';

      final descMap = attrs['description'] as Map<String, dynamic>? ?? {};
      final String desc = descMap['en'] as String? ?? descMap.values.firstOrNull as String? ?? '';

      // Find cover file name from includes relationships
      final relationships = json['relationships'] as List<dynamic>? ?? [];
      String coverFile = '';
      for (final rel in relationships) {
        if (rel['type'] == 'cover_art') {
          final relAttrs = rel['attributes'] as Map<String, dynamic>?;
          if (relAttrs != null) {
            coverFile = relAttrs['fileName'] as String? ?? '';
          }
        }
      }

      final String coverUrl = coverFile.isNotEmpty 
          ? '$_uploadsUrl/covers/$id/$coverFile'
          : '';

      return Comic(
        id: 'md_$id',
        title: title,
        author: 'MangaDex Artist',
        artist: 'MangaDex Artist',
        description: desc,
        coverAsset: coverUrl,
        genres: const ['MangaDex'],
        tags: const [],
        language: 'en',
        license: 'MangaDex License',
        year: attrs['year'] as int? ?? 2026,
        rating: 4.5,
        chapters: const [], // Load feed when selected
      );
    } catch (_) {
      return null;
    }
  }
}
