import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/tarot_card_view.dart';

class TarotCardStack extends StatelessWidget {
  const TarotCardStack({
    super.key,
    required this.assetPaths,
    this.height = 176,
  });

  final List<String> assetPaths;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cards = assetPaths.take(3).toList();

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (cards.isNotEmpty)
            Positioned(
              left: 18,
              child: TarotCardView(assetPath: cards[0], angle: -0.13),
            ),
          if (cards.length > 1) TarotCardView(assetPath: cards[1], scale: 1.08),
          if (cards.length > 2)
            Positioned(
              right: 18,
              child: TarotCardView(assetPath: cards[2], angle: 0.13),
            ),
        ],
      ),
    );
  }
}
