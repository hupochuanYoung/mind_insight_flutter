import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/components.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.person_outline_rounded,
      title: 'Me',
      subtitle: 'Your saved readings, preferences, and personal tarot journal.',
    );
  }
}
