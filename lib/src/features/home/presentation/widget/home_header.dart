import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: textRegular.copyWith(
                  color: ColorResources.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'MindInsight',
                style: textOverLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: ColorResources.ink,
                ),
              ),
            ],
          ),
        ),
        // Profile avatar button
        IconButton.filledTonal(
          onPressed: () {
            // TODO: Navigate to profile / me page
          },
          style: IconButton.styleFrom(
            fixedSize: const Size(46, 46),
            backgroundColor: ColorResources.primarySoft,
            foregroundColor: ColorResources.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
          ),
          icon: const Icon(Icons.person_outline_rounded, size: 22),
          tooltip: '我的',
        ),
      ],
    );
  }

  /// Time-aware Chinese greeting.
  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '夜深了，注意休息';
    if (hour < 12) return '早上好';
    if (hour < 14) return '中午好';
    if (hour < 18) return '下午好';
    return '晚上好';
  }
}
