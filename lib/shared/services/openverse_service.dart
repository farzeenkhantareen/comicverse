import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/comic.dart';

class OpenverseService {
  static const String _baseUrl = 'https://api.openverse.org/v1';

  final http.Client _client;

  OpenverseService({http.Client? client}) : _client = client ?? http.Client();

  /// Search openly-licensed images (CC0, PDM, BY) from Openverse to serve as illustration series
  Future<List<Comic>> searchImages(String query) async {
    if (query.isEmpty) return [];

    final Map<String, String> queryParameters = {
      'q': query,
      'license': 'by,cc0,pdm', // Restrict to safe attribution, public domain, and CC0 licenses
      'page_size': '10',
    };

    final uri = Uri.parse('$_baseUrl/images/').replace(queryParameters: queryParameters);
    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final list = data['results'] as List<dynamic>? ?? [];

      final List<Comic> results = [];
      for (final item in list) {
        final comic = _parseOpenverseImage(item);
        if (comic != null) {
          results.add(comic);
        }
      }
      return results;
    } catch (_) {
      return [];
    }
  }

  Comic? _parseOpenverseImage(Map<String, dynamic> json) {
    try {
      final String id = json['id'] as String;
      final String title = json['title'] as String? ?? 'Untitled Openverse Illustration';
      final String creator = json['creator'] as String? ?? 'Unknown Artist';
      final String source = json['source'] as String? ?? 'Openverse';
      final String url = json['url'] as String;
      final String license = json['license'] as String? ?? 'CC-licensed';

      // We wrap the single image as a 1-page comic for previewing
      return Comic(
        id: 'ov_$id',
        title: title,
        author: creator,
        artist: creator,
        publisher: source,
        description: 'An openly licensed illustration cataloged from $source. Details: ${json['attribution'] ?? ''}',
        coverAsset: url,
        genres: const ['Openverse', 'Illustration'],
        tags: const [],
        language: 'en',
        license: license.toUpperCase(),
        year: 2026,
        rating: 4.8,
        chapters: [
          Chapter(
            id: 'ov_ch_${id}',
            title: 'Full Image View',
            chapterNumber: 1,
            pages: [url],
          ),
        ],
      );
    } catch (_) {
      return null;
    }
  }
}
