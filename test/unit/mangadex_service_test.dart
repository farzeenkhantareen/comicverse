import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:comicverse/shared/services/mangadex_service.dart';

void main() {
  group('MangaDexService Tests', () {
    test('searchManga returns mapped list on success response', () async {
      final mockClient = MockClient((request) async {
        final map = {
          'data': [
            {
              'id': 'manga_id_1',
              'type': 'manga',
              'attributes': {
                'title': {'en': 'Manga Title'},
                'description': {'en': 'Desc'},
                'year': 2026,
              },
              'relationships': [
                {
                  'id': 'cover_id',
                  'type': 'cover_art',
                  'attributes': {'fileName': 'cover.jpg'}
                }
              ]
            }
          ]
        };
        return http.Response(jsonEncode(map), 200);
      });

      final service = MangaDexService(client: mockClient);
      final list = await service.searchManga('Title');

      expect(list, isNotEmpty);
      expect(list.first.title, 'Manga Title');
      expect(list.first.coverAsset, contains('cover.jpg'));
    });
  });
}
