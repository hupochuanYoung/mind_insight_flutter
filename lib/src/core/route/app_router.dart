import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_insight/di_container.dart';
import 'package:mind_insight/src/core/component/portal_master_layout.dart';
import 'package:mind_insight/src/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:mind_insight/src/features/auth/presentation/screen/login_screen.dart';
import 'package:mind_insight/src/features/chat/presentation/screen/chat_page.dart';
import 'package:mind_insight/src/features/home/presentation/screen/home_page.dart';
import 'package:mind_insight/src/features/home/presentation/screen/me_page.dart';

// =============================================================================
// Route URI constants
// =============================================================================

class RouteUri {
  const RouteUri._();

  // Auth routes
  static const String login = '/login';

  // Tab routes
  static const String home = '/home';
  static const String chat = '/chat';
  static const String me = '/me';

  // Non-tab routes (add as features grow)
  static const String chatSession = '/chat-session';
  static const String error = '/error';
}

// =============================================================================
// Navigation helper
// =============================================================================

/// Pop using GoRouter if possible, falling back to Navigator.
void popIfPossible(BuildContext context, {String? fallbackPath}) {
  final router = GoRouter.of(context);
  final navigator = Navigator.of(context);

  // If in a dialog/modal, use Navigator.pop()
  final route = ModalRoute.of(context);
  if (route is PopupRoute && navigator.canPop()) {
    navigator.pop();
    return;
  }

  // Prefer GoRouter for deep-linking consistency
  if (router.canPop()) {
    router.pop();
    return;
  }

  // Fallback to Navigator
  if (navigator.canPop()) {
    navigator.pop();
    return;
  }

  // Last resort: navigate to a known route
  if (fallbackPath != null) {
    router.go(fallbackPath);
  }
}

// =============================================================================
// Custom page transitions
// =============================================================================

CustomTransitionPage<T> fadeTransitionPage<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

CustomTransitionPage<T> slideTransitionPage<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0);
      const end = Offset.zero;
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: Curves.ease));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

CustomTransitionPage<T> slideTopDownTransitionPage<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0, -1.0);
      const end = Offset.zero;
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: Curves.ease));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

// =============================================================================
// App Router
// =============================================================================

GoRouter appRouter(GlobalKey<NavigatorState> navigatorKey) {
  return GoRouter(
    initialLocation: RouteUri.home,
    navigatorKey: navigatorKey,
    redirect: (context, state) {
      final token = sl<AuthLocalDatasource>().getToken();
      final isLoggedIn = token != null && token.isNotEmpty;
      final isOnLogin = state.matchedLocation == RouteUri.login;

      // Not logged in and not on login page → redirect to login
      if (!isLoggedIn && !isOnLogin) return RouteUri.login;

      // Logged in but still on login page → redirect to home
      if (isLoggedIn && isOnLogin) return RouteUri.home;

      return null; // no redirect
    },
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
    routes: [
      // -----------------------------------------------------------------------
      // Login route (outside shell — no bottom nav)
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteUri.login,
        pageBuilder: (context, state) =>
            fadeTransitionPage(state: state, child: const LoginScreen()),
      ),

      // -----------------------------------------------------------------------
      // Bottom navigation shell — preserves state across tabs
      // -----------------------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MasterLayout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteUri.home,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteUri.chat,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const ChatPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteUri.me,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const MePage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // Non-tab routes (pushed on top of the shell)
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteUri.chatSession,
        pageBuilder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'daily_fortune';
          return slideTransitionPage(
            state: state,
            child: ChatPage(entryType: type),
          );
        },
      ),
    ],
  );
}
