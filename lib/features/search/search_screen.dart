import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/providers.dart';
import '../../shared/widgets/comic_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/shimmer_loading.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchResultsProvider);
    final selectedGenres = ref.watch(selectedGenresProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Panel
            Padding(
              padding: const EdgeInsets.all(AppSizes.pagePaddingH),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        ref.read(searchQueryProvider.notifier).state = val;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: AppStrings.searchHint,
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Genres Filters
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePaddingH),
                itemCount: AppStrings.allCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final genre = AppStrings.allCategories[index];
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      final current = [...selectedGenres];
                      if (selected) {
                        current.add(genre);
                      } else {
                        current.remove(genre);
                      }
                      ref.read(selectedGenresProvider.notifier).state = current;
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Search Results Grid
            Expanded(
              child: searchResults.when(
                data: (comics) {
                  if (comics.isEmpty) {
                    return const EmptyState(
                      icon: Icons.search_off_rounded,
                      title: AppStrings.searchEmpty,
                      subtitle: AppStrings.searchEmptySubtitle,
                    );
                  }
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppSizes.pagePaddingH),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: AppSizes.coverAspectRatio,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: comics.length,
                    itemBuilder: (context, index) {
                      return ComicCard(
                        comic: comics[index],
                        heroTagPrefix: 'search',
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryPurple),
                ),
                error: (_, __) => const EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Failed to load search results',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
