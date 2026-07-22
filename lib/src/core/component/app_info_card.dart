import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/app_colors.dart';
import 'package:mind_insight/src/core/component/app_icon_badge.dart';

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.backgroundColor = const Color(0xFFEAF6F1),
    this.borderColor = const Color(0xFFD3E9DF),
    this.iconColor = AppColors.teal,
    this.bodyColor = const Color(0xFF4B5F58),
  });

  final IconData icon;
  final String title;
  final String body;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color bodyColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBadge(icon: icon, backgroundColor: iconColor),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: bodyColor,
                    height: 1.38,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
