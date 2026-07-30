import 'package:flutter_test/flutter_test.dart';
import 'package:comicverse/shared/models/comic.dart';

void main() {
  group('Comic Model Tests', () {
    test('Comic model correctly parses tags and computes chapters counts', () {
      const comic = Comic(
        id: 'test_id',
        title: 'Test Title',
        author: 'Author',
        artist: 'Artist',
        description: 'Desc',
        coverAsset: 'cover.png',
        genres: ['Action'],
        tags: ['tag1'],
        language: 'English',
        license: 'Public Domain',
        year: 2026,
        rating: 4.5,
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Ch1',
            chapterNumber: 1,
            pages: ['page1.png'],
          )
        ],
      );

      expect(comic.id, 'test_id');
      expect(comic.genres.first, 'Action');
      expect(comic.chapterCount, '1 Chapter');
      expect(comic.isPublicDomain, isTrue);
    });
  });
}
