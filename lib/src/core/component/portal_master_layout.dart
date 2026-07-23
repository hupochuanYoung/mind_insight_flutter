import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';

/// Shell widget that wraps the bottom navigation bar around tab content.
///
/// Uses [StatefulNavigationShell] from go_router to preserve each tab's state
/// (scroll position, form input, etc.) when switching between tabs — same
/// pattern as the tongzhou-app-flutter MasterLayout.
class MasterLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MasterLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: navigationShell.currentIndex,
      onTap: (index) => _onTap(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: ColorResources.primary,
      unselectedItemColor: ColorResources.muted,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          activeIcon: Icon(Icons.chat_bubble_rounded),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          activeIcon: Icon(Icons.person_rounded),
          label: 'Me',
        ),
      ],
    );
  }

  void _onTap(BuildContext context, int index) {
    // goBranch navigates to the branch at [index], preserving its state.
    // If the user taps the already-active tab, initialLocation resets it
    // to the branch root (scroll-to-top behavior).
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
