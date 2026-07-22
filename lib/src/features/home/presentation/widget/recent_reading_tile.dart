import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/components.dart';

class RecentReadingTile extends StatelessWidget {
  const RecentReadingTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });

  final String title;
  final String subtitle;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return AppReadingTile(
      title: title,
      subtitle: subtitle,
      assetPath: assetPath,
    );
  }
}
