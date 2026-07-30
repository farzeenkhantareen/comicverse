import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/comic.dart';

class ComicVineService {
  static const String _baseUrl = 'https://comicvine.gamespot.com/api';
  static const String _apiKey = '0ad46f8214cc92a249ae35ae020d52b97608b6da';

  final http.Client _client;

  ComicVineService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'User-Agent': 'ComicVerseApp/1.0.0 (farzeenkhantareen)',
        'Accept': 'application/json',
      };

  /// Search volumes (comic series)
  Future<List<Comic>> searchVolumes(String query) async {
    if (query.isEmpty) return [];

    final uri = Uri.parse('$_baseUrl/search/').replace(queryParameters: {
      'api_key': _apiKey,
      'format': 'json',
      'query': query,
      'resources': 'volume',
      'limit': '15',
    });

    try {
      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final list = data['results'] as List<dynamic>? ?? [];

      final List<Comic> results = [];
      for (final item in list) {
        final comic = _parseVolume(item);
        if (comic != null) {
          results.add(comic);
        }
      }
      return results;
    } catch (_) {
      return [];
    }
  }

  /// Get details of a single volume
  Future<Comic?> getVolumeDetails(String volumeId) async {
    final uri = Uri.parse('$_baseUrl/volume/4050-$volumeId/').replace(queryParameters: {
      'api_key': _apiKey,
      'format': 'json',
    });

    try {
      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final results = data['results'] as Map<String, dynamic>?;
      if (results == null) return null;

      final comic = _parseVolume(results);
      if (comic == null) return null;

      final chapters = await getVolumeIssues(volumeId);
      return Comic(
        id: comic.id,
        title: comic.title,
        author: comic.author,
        artist: comic.artist,
        description: comic.description,
        coverAsset: comic.coverAsset,
        genres: comic.genres,
        tags: comic.tags,
        language: comic.language,
        license: comic.license,
        year: comic.year,
        rating: comic.rating,
        chapters: chapters,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get details of a volume (including its issues)
  Future<List<Chapter>> getVolumeIssues(String volumeId) async {
    final uri = Uri.parse('$_baseUrl/volume/4050-$volumeId/').replace(queryParameters: {
      'api_key': _apiKey,
      'format': 'json',
      'field_list': 'issues',
    });

    try {
      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final results = data['results'] as Map<String, dynamic>? ?? {};
      final list = results['issues'] as List<dynamic>? ?? [];

      final List<Chapter> chapters = [];
      for (final item in list) {
        final String issueId = item['id'].toString();
        final String name = item['name'] as String? ?? 'Issue';
        final String issueNumStr = item['issue_number'] as String? ?? '1';
        final double? issueNumVal = double.tryParse(issueNumStr);
        final int issueNum = issueNumVal?.toInt() ?? 1;

        // Since Comic Vine API does not serve full page contents (it is a wiki), 
        // we dynamically build mock pages using gorgeous open-source covers and sample illustrations.
        chapters.add(Chapter(
          id: 'cv_issue_$issueId',
          title: name.isNotEmpty ? 'No. $issueNumStr: $name' : 'Issue #$issueNumStr',
          chapterNumber: issueNum,
          pages: [
            // Cover/illustrations
            'https://picsum.photos/id/${(int.tryParse(issueId) ?? 100) % 1000}/800/1200',
            'https://picsum.photos/id/${((int.tryParse(issueId) ?? 100) + 1) % 1000}/800/1200',
            'https://picsum.photos/id/${((int.tryParse(issueId) ?? 100) + 2) % 1000}/800/1200',
            'https://picsum.photos/id/${((int.tryParse(issueId) ?? 100) + 3) % 1000}/800/1200',
          ],
        ));
      }

      // Sort by issue/chapter number
      chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
      return chapters;
    } catch (_) {
      return [];
    }
  }

  Comic? _parseVolume(Map<String, dynamic> json) {
    try {
      final String id = json['id'].toString();
      final String title = json['name'] as String? ?? 'Unknown Comic';
      final String desc = json['description'] as String? ?? '';
      
      final image = json['image'] as Map<String, dynamic>? ?? {};
      final String coverUrl = image['medium_url'] as String? ?? image['original_url'] as String? ?? '';

      final publisher = json['publisher'] as Map<String, dynamic>? ?? {};
      final String publisherName = publisher['name'] as String? ?? 'Comic Vine Publisher';

      final String startYear = json['start_year'] as String? ?? '2026';
      final int year = int.tryParse(startYear) ?? 2026;

      return Comic(
        id: 'cv_$id',
        title: title,
        author: publisherName,
        artist: publisherName,
        description: desc.replaceAll(RegExp(r'<[^>]*>'), ''), // strip HTML tags
        coverAsset: coverUrl,
        genres: const ['Comic Vine'],
        tags: const ['Comic Vine'],
        language: 'en',
        license: 'Comic Vine Metadata',
        year: year,
        rating: 4.6,
        chapters: const [], // loaded dynamically
      );
    } catch (_) {
      return null;
    }
  }
}
