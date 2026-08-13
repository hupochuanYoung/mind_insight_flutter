import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';

import 'genui_registry.dart';

/// Card shuffle & selection widget — smooth 2D ellipse carousel.
///
/// Cards sit on an elliptical ring. Horizontal swipe rotates the ring.
/// Vertical swipe changes the ellipse "flatness" to simulate viewing angle.
/// No 3D transforms — only position, scale, and opacity for flicker-free rendering.
class CardShuffleWidget extends StatefulWidget {
  const CardShuffleWidget({
    super.key,
    required this.data,
    required this.onAction,
  });

  final Map<String, dynamic> data;
  final GenUiActionCallback onAction;

  @override
  State<CardShuffleWidget> createState() => _CardShuffleWidgetState();
}

class _CardShuffleWidgetState extends State<CardShuffleWidget>
    with SingleTickerProviderStateMixin {
  static const int _totalCards = 22;
  static const double _cardWidth = 52.0;
  static const double _cardHeight = 82.0;

  final List<int> _selectedIndexes = [];
  late final int _requiredCards;

  // Intro animation
  late final AnimationController _introController;
  late final Animation<double> _introAnim;
  bool _isShuffling = true;
  bool _isConfirmed = false;

  // Ring state
  double _rotation = 0.0;
  double _perspective = 0.55; // >0 looking down, <0 looking up

  static const double _minPerspective = -0.85;
  static const double _maxPerspective = 0.85;

  // Fling
  double _flingTarget = 0.0;
  double _flingStart = 0.0;
  bool _flinging = false;
  double _flingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _requiredCards = widget.data['requiredCards'] as int? ?? 1;

    _introController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _introAnim = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOutCubic,
    );
    _introController.addListener(() => setState(() {}));
    _introController.forward().then((_) {
      if (mounted) setState(() => _isShuffling = false);
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  // --- Gesture handling ---
  // GestureDetector with onTapUp + onPan* allows tap and drag to coexist.
  // Once pan is recognized, it claims the gesture arena and blocks parent scroll.

  void _onTapUp(TapUpDetails details) {
    if (_isShuffling || _isConfirmed) return;
    _handleTapAt(details.localPosition);
  }

  void _onPanStart(DragStartDetails details) {
    _flinging = false;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isShuffling || _isConfirmed) return;
    setState(() {
      _rotation += details.delta.dx * 0.005;
      _perspective = (_perspective + details.delta.dy * 0.003).clamp(
        _minPerspective,
        _maxPerspective,
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isShuffling || _isConfirmed) return;
    final vx = details.velocity.pixelsPerSecond.dx;
    if (vx.abs() > 200) {
      _flingStart = _rotation;
      _flingTarget = _rotation + vx * 0.0015;
      _flingProgress = 0.0;
      _flinging = true;
      _animateFling();
    }
  }

  void _animateFling() {
    if (!_flinging || !mounted) return;
    _flingProgress += 0.04;
    if (_flingProgress >= 1.0) {
      _flinging = false;
      setState(() => _rotation = _flingTarget);
      return;
    }
    final t = 1.0 - pow(1.0 - _flingProgress, 3).toDouble();
    setState(() {
      _rotation = _flingStart + (_flingTarget - _flingStart) * t;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateFling());
  }

  /// Find the front-most card at the given local position and select it.
  void _handleTapAt(Offset localPos) {
    final width = MediaQuery.of(context).size.width - 80;
    const height = 200.0;
    final radiusX = width * 0.40;
    final radiusY = 60.0 * _perspective;
    final angleStep = (2 * pi) / _totalCards;

    int? bestIndex;
    double bestScore = double.negativeInfinity;

    for (int i = 0; i < _totalCards; i++) {
      final angle = angleStep * i + _rotation;
      final x = sin(angle) * radiusX;
      final y = -cos(angle) * radiusY;
      final depth = _perspective >= 0 ? cos(angle) : -cos(angle);
      final scale = 0.65 + 0.35 * ((depth + 1) / 2);

      final cardCenterX = width / 2 + x;
      final cardCenterY = height / 2 + y;

      final dx = localPos.dx - cardCenterX;
      final dy = localPos.dy - cardCenterY;
      final hitW = _cardWidth * scale / 2;
      final hitH = _cardHeight * scale / 2;

      if (dx.abs() < hitW && dy.abs() < hitH) {
        if (depth > bestScore) {
          bestScore = depth;
          bestIndex = i;
        }
      }
    }

    if (bestIndex != null) {
      _onCardTap(bestIndex);
    }
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
    setState(() => _selectedIndexes.clear());
  }

  // --- Build ---

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
          if (!_isConfirmed && !_isShuffling) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.swipe_rounded,
                  size: 14,
                  color: ColorResources.muted.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  '左右旋转 · 上下切换视角',
                  style: textSmall.copyWith(
                    color: ColorResources.muted.withValues(alpha: 0.5),
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
                final filled = i < _selectedIndexes.length;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: filled
                        ? ColorResources.primary.withValues(alpha: 0.15)
                        : ColorResources.primarySoft,
                    borderRadius: BorderRadius.circular(16),
                    border: filled
                        ? Border.all(color: ColorResources.primary, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    positions[i],
                    style: textSmall.copyWith(
                      color: filled
                          ? ColorResources.primary
                          : ColorResources.muted,
                      fontWeight: filled ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                );
              }),
            ),
          ],
          const SizedBox(height: 12),
          // Carousel — GestureDetector claims pan to block parent scroll; tap coexists
          GestureDetector(
            onTapUp: _onTapUp,
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(height: 200, child: _buildCarousel()),
          ),
          // Buttons
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

  /// Pure 2D ellipse carousel.
  Widget _buildCarousel() {
    final width = MediaQuery.of(context).size.width - 80;
    const height = 200.0;

    final radiusX = width * 0.40;
    final radiusY = 60.0 * _perspective;

    final introT = _introAnim.value;
    final angleStep = (2 * pi) / _totalCards;

    final items = <_CardItem>[];
    for (int i = 0; i < _totalCards; i++) {
      final angle = _isShuffling
          ? angleStep * i * introT + _rotation
          : angleStep * i + _rotation;

      final x = sin(angle) * radiusX * introT;
      final y = -cos(angle) * radiusY * introT;

      // Depth flips based on viewing direction
      final depth = _perspective >= 0 ? cos(angle) : -cos(angle);

      final scale = 0.65 + 0.35 * ((depth + 1) / 2);
      final opacity = 0.4 + 0.6 * ((depth + 1) / 2);

      items.add(
        _CardItem(
          index: i,
          x: x,
          y: y,
          depth: depth,
          scale: scale,
          opacity: opacity,
        ),
      );
    }

    // Stable sort: back first, index tiebreaker
    items.sort((a, b) {
      final cmp = (a.depth * 10000).round().compareTo(
        (b.depth * 10000).round(),
      );
      return cmp != 0 ? cmp : a.index.compareTo(b.index);
    });

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: items.map((item) {
          final isSelected = _selectedIndexes.contains(item.index);
          final cx = width / 2 + item.x - _cardWidth / 2;
          final selectedOffset = isSelected ? -28.0 : 0.0;

          return Positioned(
            left: cx,
            top: height / 2 + item.y - _cardHeight / 2,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: selectedOffset),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, yOffset, child) {
                return Transform.translate(
                  offset: Offset(0, yOffset),
                  child: child,
                );
              },
              child: _buildCard(item, isSelected),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCard(_CardItem item, bool isSelected) {
    final isFront = item.depth > 0.2;
    final alpha = item.opacity.clamp(0.0, 1.0);

    return Transform.scale(
      scale: item.scale,
      child: Container(
        width: _cardWidth,
        height: _cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? ColorResources.primary.withValues(alpha: alpha)
                : Colors.white.withValues(alpha: 0.15 * alpha),
            width: isSelected ? 2.5 : 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    ColorResources.primary.withValues(alpha: 0.3 * alpha),
                    ColorResources.primary.withValues(alpha: 0.1 * alpha),
                  ]
                : [
                    Color.lerp(
                      const Color(0xFF4A3580),
                      const Color(0xFFFFF8EF),
                      1 - alpha,
                    )!,
                    Color.lerp(
                      const Color(0xFF1E1245),
                      const Color(0xFFFFF8EF),
                      1 - alpha,
                    )!,
                  ],
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: ColorResources.primary.withValues(alpha: 0.4 * alpha),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: (isFront ? 0.2 : 0.08) * alpha,
                ),
                blurRadius: isFront ? 8 : 3,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: isSelected
              ? Icon(
                  Icons.check_rounded,
                  color: ColorResources.primary.withValues(alpha: alpha),
                  size: 20,
                )
              : Icon(
                  Icons.auto_awesome,
                  color: Colors.white.withValues(alpha: 0.3 * alpha),
                  size: 13,
                ),
        ),
      ),
    );
  }
}

class _CardItem {
  final int index;
  final double x;
  final double y;
  final double depth;
  final double scale;
  final double opacity;

  const _CardItem({
    required this.index,
    required this.x,
    required this.y,
    required this.depth,
    required this.scale,
    required this.opacity,
  });
}
