import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:comicverse/shared/services/openverse_service.dart';

void main() {
  group('OpenverseService Tests', () {
    test('searchImages returns parsed comic illustrations on successful API response', () async {
      final mockClient = MockClient((request) async {
        final map = {
          'results': [
            {
              'id': 'image_id_123',
              'title': 'Creative Commons Sketch',
              'creator': 'Open Artist',
              'source': 'Flickr',
              'url': 'https://example.com/cc_sketch.jpg',
              'license': 'by',
              'attribution': 'Sketch by Open Artist CC BY 2.0'
            }
          ]
        };
        return http.Response(jsonEncode(map), 200);
      });

      final service = OpenverseService(client: mockClient);
      final list = await service.searchImages('sketch');

      expect(list, isNotEmpty);
      expect(list.first.title, 'Creative Commons Sketch');
      expect(list.first.coverAsset, 'https://example.com/cc_sketch.jpg');
      expect(list.first.license, 'BY');
    });
  });
}
