import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/components.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppInfoCard(
      icon: Icons.psychology_alt_outlined,
      title: 'Your pattern this week',
      body:
          'You keep drawing cards about choice and patience. Move slowly, but choose clearly.',
    );
  }
}
