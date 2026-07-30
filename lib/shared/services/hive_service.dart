import 'package:hive_flutter/hive_flutter.dart';

/// Centralized Hive initialization and box access
abstract final class HiveService {
  static const String _readingProgressBoxName = 'reading_progress';
  static const String _bookmarksBoxName = 'bookmarks';
  static const String _settingsBoxName = 'settings';

  static late Box _readingProgressBox;
  static late Box _bookmarksBox;
  static late Box _settingsBox;

  static Box get readingProgressBox => _readingProgressBox;
  static Box get bookmarksBox => _bookmarksBox;
  static Box get settingsBox => _settingsBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();

    _readingProgressBox = await Hive.openBox(_readingProgressBoxName);
    _bookmarksBox = await Hive.openBox(_bookmarksBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  static Future<void> clearAll() async {
    await _readingProgressBox.clear();
    await _bookmarksBox.clear();
  }

  static Future<int> totalSizeBytes() async {
    // Approximate size by counting entries
    return (_readingProgressBox.length + _bookmarksBox.length) * 512;
  }
}
