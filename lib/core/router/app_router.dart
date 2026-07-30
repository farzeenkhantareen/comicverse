import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/reader/reader_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../shared/models/comic.dart';

/// Route names as constants — never use raw strings
abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String shell = '/shell';
  static const String home = '/home';
  static const String search = '/search';
  static const String library = '/library';
  static const String settings = '/settings';
  static const String reader = '/reader';
  static const String categories = '/categories';
  static const String categoryDetail = '/categories/:id';
}

/// Global key for the shell navigator (avoids rebuilding bottom nav)
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Provider for the GoRouter instance
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      // ── Splash ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // ── Onboarding ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // ── Main App Shell (with bottom nav) ────────────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.search,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SearchScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.library,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const LibraryScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),

      // ── Reader (full-screen, no bottom nav) ────────────────────────────
      GoRoute(
        path: '${AppRoutes.reader}/:comicId',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final comicId = state.pathParameters['comicId']!;
          final chapterIndex = int.tryParse(
            state.uri.queryParameters['chapter'] ?? '0',
          ) ?? 0;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ReaderScreen(comicId: comicId, initialChapter: chapterIndex),
            transitionsBuilder: _fadeScaleTransition,
          );
        },
      ),

      // ── Categories ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.categories,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CategoriesScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
    ],
  );
});

// ── Transition Builders ──────────────────────────────────────────────────────

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}

Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
    child: child,
  );
}

Widget _fadeScaleTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      ),
      child: child,
    ),
  );
}

/// Shell wrapper that provides the bottom navigation bar
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  static const _tabs = [
    AppRoutes.home,
    AppRoutes.search,
    AppRoutes.library,
    AppRoutes.settings,
  ];

  void _onTap(int index) {
    if (index == _currentIndex) {
      // Already on tab — scroll to top (implement via scroll controllers if needed)
      return;
    }
    setState(() => _currentIndex = index);
    context.go(_tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      height: 72,
      animationDuration: const Duration(milliseconds: 300),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search_rounded),
          label: 'Discover',
        ),
        NavigationDestination(
          icon: Icon(Icons.collections_bookmark_outlined),
          selectedIcon: Icon(Icons.collections_bookmark_rounded),
          label: 'Library',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings_rounded),
          label: 'Settings',
        ),
      ],
    );
  }
}
