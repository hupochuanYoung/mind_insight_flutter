import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/app_colors.dart';

class AppActionButton extends StatelessWidget {
  const AppActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = AppColors.gold,
    this.foregroundColor = AppColors.ink,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: icon == null
          ? FilledButton(
              onPressed: onPressed,
              style: style,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            )
          : FilledButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon),
              label: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
    );
  }
}
