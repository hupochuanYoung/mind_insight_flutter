import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/app_colors.dart';

class TarotCardView extends StatelessWidget {
  const TarotCardView({
    super.key,
    required this.assetPath,
    this.width = 92,
    this.height = 156,
    this.angle = 0,
    this.scale = 1,
    this.borderColor = const Color(0xFFFFF3C9),
    this.borderWidth = 3,
    this.showShadow = true,
  });

  final String assetPath;
  final double width;
  final double height;
  final double angle;
  final double scale;
  final Color borderColor;
  final double borderWidth;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: showShadow
                ? const [
                    BoxShadow(
                      color: Color(0x59211D33),
                      blurRadius: 18,
                      offset: Offset(0, 9),
                    ),
                  ]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(assetPath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
