import 'package:flutter/material.dart';
import 'package:mind_insight/src/features/profile/presentation/screen/profile_screen.dart';

/// "Me" tab — delegates to the full Profile page.
class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}
