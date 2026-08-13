import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';

import 'genui_registry.dart';

/// Card shuffle & selection widget — circular carousel style.
///
/// Cards are arranged in a 3D circle. User swipes left/right to rotate the
/// ring and taps a card to select it. Once all required cards are selected,
/// confirm/cancel buttons appear.
class CardShuffleWidget extends StatefulWidget {
  const CardShuffleWidget({
    super.key,
    required this.data,
    required this.onAction,
  });

  /// Expected keys in data:
  /// - `requiredCards`: int — how many cards user must pick
  /// - `spreadName`: String — name of the spread
  /// - `positions`: list of strings — position labels
  /// - `tarotSessionId`: int — ID to use for reveal
  final Map<String, dynamic> data;
  final GenUiActionCallback onAction;

  @override
  State<CardShuffleWidget> createState() => _CardShuffleWidgetState();
}

class _CardShuffleWidgetState extends State<CardShuffleWidget>
    with TickerProviderStateMixin {
  static const int _totalCards = 22; // Major Arcana pool
  final List<int> _selectedIndexes = [];
  late final int _requiredCards;

  // Shuffle intro animation
  late final AnimationController _shuffleController;
  late final Animation<double> _shuffleAnimation;
  bool _isShuffling = true;
  bool _isConfirmed = false;

  // Carousel rotation state
  double _rotationAngle = 0.0; // current rotation in radians
  double _dragStartAngle = 0.0;

  // Momentum / fling animation
  late AnimationController _flingController;
  late Animation<double> _flingAnimation;

  @override
  void initState() {
    super.initState();
    _requiredCards = widget.data['requiredCards'] as int? ?? 1;

    _shuffleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _shuffleAnimation = CurvedAnimation(
      parent: _shuffleController,
      curve: Curves.easeOutBack,
    );
    _shuffleController.forward().then((_) {
      if (mounted) setState(() => _isShuffling = false);
    });

    _flingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flingAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _flingController, curve: Curves.easeOutCubic),
    );
    _flingController.addListener(() {
      setState(() => _rotationAngle = _flingAnimation.value);
    });
  }

  @override
  void dispose() {
    _shuffleController.dispose();
    _flingController.dispose();
    super.dispose();
  }

  void _onCardTap(int index) {
    if (_isShuffling || _isConfirmed) return;

    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else if (_selectedIndexes.length < _requiredCards) {
        _selectedIndexes.add(index);
      }
    });
  }

  void _onConfirm() {
    if (_selectedIndexes.length != _requiredCards) return;
    setState(() => _isConfirmed = true);
    widget.onAction('reveal_cards', {
      ...widget.data,
      'selectedIndexes': _selectedIndexes,
    });
  }

  void _onCancel() {
    setState(() {
      _selectedIndexes.clear();
    });
  }

  void _onPanStart(DragStartDetails details) {
    _flingController.stop();
    _dragStartAngle = _rotationAngle;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isShuffling || _isConfirmed) return;
    setState(() {
      _rotationAngle += details.delta.dx * 0.008;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isShuffling || _isConfirmed) return;
    // Fling with momentum
    final velocity = details.velocity.pixelsPerSecond.dx * 0.005;
    final endAngle = _rotationAngle + velocity;

    _flingAnimation = Tween<double>(begin: _rotationAngle, end: endAngle)
        .animate(
          CurvedAnimation(parent: _flingController, curve: Curves.easeOutCubic),
        );
    _flingController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final positions =
        (widget.data['positions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final remaining = _requiredCards - _selectedIndexes.length;
    final allSelected = _selectedIndexes.length == _requiredCards;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        border: Border.all(color: ColorResources.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.style_rounded,
                size: 20,
                color: ColorResources.primary,
              ),
              const SizedBox(width: 8),
              Text(
                _isConfirmed
                    ? '已选定 $_requiredCards 张牌'
                    : _isShuffling
                    ? '正在洗牌...'
                    : '选择 $_requiredCards 张牌',
                style: textBoldLarge.copyWith(color: ColorResources.ink),
              ),
            ],
          ),
          if (!_isConfirmed && !_isShuffling) ...[
            const SizedBox(height: 4),
            Text(
              remaining > 0 ? '还需选择 $remaining 张' : '已选好，请确认',
              style: textSmall.copyWith(
                color: allSelected
                    ? ColorResources.primary
                    : ColorResources.muted,
                fontWeight: allSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
          // Swipe hint
          if (!_isConfirmed && !_isShuffling) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.swipe_rounded,
                  size: 14,
                  color: ColorResources.muted.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  '左右滑动旋转牌阵',
                  style: textSmall.copyWith(
                    color: ColorResources.muted.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
          // Position hints
          if (positions.isNotEmpty && !_isConfirmed) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: List.generate(positions.length, (i) {
                final isSelected = i < _selectedIndexes.length;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorResources.primary.withValues(alpha: 0.15)
                        : ColorResources.primarySoft,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: ColorResources.primary, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    positions[i],
                    style: textSmall.copyWith(
                      color: isSelected
                          ? ColorResources.primary
                          : ColorResources.muted,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                );
              }),
            ),
          ],
          const SizedBox(height: 16),
          // Circular carousel
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: AnimatedBuilder(
              animation: _shuffleAnimation,
              builder: (context, _) {
                return SizedBox(
                  height: 200,
                  child: Center(child: _buildCircularCarousel()),
                );
              },
            ),
          ),
          // Confirm / Cancel buttons
          if (allSelected && !_isConfirmed) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ColorResources.muted,
                      side: const BorderSide(color: ColorResources.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      '重新选择',
                      style: textMedium.copyWith(color: ColorResources.muted),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_rounded, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '确认翻牌',
                          style: textBoldLarge.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
          // Confirmed state indicator
          if (_isConfirmed) ...[
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: ColorResources.teal,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '已确认，正在翻牌...',
                    style: textSmall.copyWith(color: ColorResources.teal),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCircularCarousel() {
    final containerWidth = MediaQuery.of(context).size.width - 80;
    // Ellipse radii for the circular arrangement
    final radiusX = containerWidth * 0.40; // horizontal radius
    const radiusY = 50.0; // vertical radius (perspective squash)

    // Build card data with z-ordering
    final cards = <_CarouselCard>[];
    final angleStep = (2 * pi) / _totalCards;

    for (int i = 0; i < _totalCards; i++) {
      // During shuffle intro, animate from stacked to circle
      final effectiveAngle = _isShuffling
          ? angleStep * i * _shuffleAnimation.value
          : angleStep * i + _rotationAngle;

      final x = sin(effectiveAngle) * radiusX;
      final z = cos(effectiveAngle); // -1 to 1, back to front

      // Scale and opacity based on depth
      final scale = 0.6 + 0.4 * ((z + 1) / 2); // 0.6 at back, 1.0 at front
      final opacity = 0.4 + 0.6 * ((z + 1) / 2); // 0.4 at back, 1.0 at front
      final yOffset =
          -z * radiusY * _shuffleAnimation.value; // perspective Y shift

      cards.add(
        _CarouselCard(
          index: i,
          x: x,
          y: yOffset,
          z: z,
          scale: scale,
          opacity: opacity,
          angle: effectiveAngle,
        ),
      );
    }

    // Sort by z so back cards render first (painter's algorithm)
    cards.sort((a, b) => a.z.compareTo(b.z));

    return SizedBox(
      width: containerWidth,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: cards.map((card) {
          final isSelected = _selectedIndexes.contains(card.index);
          return Positioned(
            left: (containerWidth / 2) + card.x - 28,
            top: 55 + card.y + (isSelected ? -10 : 0),
            child: GestureDetector(
              onTap: () => _onCardTap(card.index),
              child: Transform.scale(
                scale: card.scale,
                child: Opacity(
                  opacity: card.opacity.clamp(0.0, 1.0),
                  child: _buildSingleCard(card.index, isSelected, card.z > 0.3),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSingleCard(int index, bool isSelected, bool isFront) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 56,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected
              ? ColorResources.primary
              : ColorResources.primary.withValues(alpha: 0.3),
          width: isSelected ? 2.5 : 1.5,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? [
                  ColorResources.primary.withValues(alpha: 0.25),
                  ColorResources.primary.withValues(alpha: 0.08),
                ]
              : [const Color(0xFF3D2A6E), const Color(0xFF1A1035)],
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: ColorResources.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isFront ? 0.25 : 0.1),
                  blurRadius: isFront ? 8 : 3,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Center(
        child: isSelected
            ? const Icon(
                Icons.check_rounded,
                color: ColorResources.primary,
                size: 22,
              )
            : Icon(
                Icons.auto_awesome,
                color: Colors.white.withValues(alpha: 0.4),
                size: 16,
              ),
      ),
    );
  }
}

/// Internal model to represent a card's position in the carousel.
class _CarouselCard {
  final int index;
  final double x;
  final double y;
  final double z;
  final double scale;
  final double opacity;
  final double angle;

  const _CarouselCard({
    required this.index,
    required this.x,
    required this.y,
    required this.z,
    required this.scale,
    required this.opacity,
    required this.angle,
  });
}
