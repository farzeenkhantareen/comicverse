import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/di/providers.dart';
import '../../shared/models/comic.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final readingDir = ref.watch(readingDirectionProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Theme Section
          _SectionTitle(title: 'Appearance'),
          ListTile(
            title: const Text('Light Theme', style: TextStyle(color: Colors.white)),
            trailing: Switch(
              value: themeMode == ThemeMode.light,
              onChanged: (isLight) {
                ref.read(themeModeProvider.notifier).setTheme(
                      isLight ? ThemeMode.light : ThemeMode.dark,
                    );
              },
            ),
          ),
          Divider(color: AppColors.outlineVariant, indent: 16, endIndent: 16),

          // Reading Section
          _SectionTitle(title: 'Reading Config'),
          ListTile(
            title: const Text('Reading Orientation', style: TextStyle(color: Colors.white)),
            subtitle: Text(
              readingDir == ReadingDirection.vertical
                  ? 'Vertical Webtoon Scroll'
                  : readingDir == ReadingDirection.rtl
                      ? 'Right to Left (Manga)'
                      : 'Left to Right (Western)',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white70),
            onTap: () {
              final nextIndex = (readingDir.index + 1) % ReadingDirection.values.length;
              ref.read(readingDirectionProvider.notifier).set(
                    ReadingDirection.values[nextIndex],
                  );
            },
          ),
          Divider(color: AppColors.outlineVariant, indent: 16, endIndent: 16),

          // Legal Section
          _SectionTitle(title: 'Legal & Info'),
          ListTile(
            title: const Text('About ComicVerse', style: TextStyle(color: Colors.white)),
            subtitle: const Text('License and redistribution info', style: TextStyle(color: AppColors.textSecondary)),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'ComicVerse',
      applicationVersion: '1.0.0',
      applicationLegalese: 'ComicVerse is an offline comic reader app delivering legally redistributable classics and original AI stories. No user data is gathered or stored.',
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primaryPurpleLight,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
