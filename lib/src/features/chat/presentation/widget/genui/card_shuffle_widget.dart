import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';

import 'genui_registry.dart';

/// Card shuffle & selection widget — user picks N cards from a shuffled fan.
///
/// Used when the tarot session is created (status: "created") and user
/// needs to select their cards. Not driven by a specific `ui_view` from agent,
/// but inserted by the chat page after a successful draw creation.
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
  late final AnimationController _shuffleController;
  late final Animation<double> _shuffleAnimation;
  bool _isShuffling = true;
  bool _isSubmitted = false;

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
    // Start shuffle animation
    _shuffleController.forward().then((_) {
      if (mounted) setState(() => _isShuffling = false);
    });
  }

  @override
  void dispose() {
    _shuffleController.dispose();
    super.dispose();
  }

  void _onCardTap(int index) {
    if (_isShuffling || _isSubmitted) return;

    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else if (_selectedIndexes.length < _requiredCards) {
        _selectedIndexes.add(index);
      }
    });

    // Auto-submit when all cards are selected
    if (_selectedIndexes.length == _requiredCards) {
      _submit();
    }
  }

  void _submit() {
    setState(() => _isSubmitted = true);
    widget.onAction('reveal_cards', {
      ...widget.data,
      'selectedIndexes': _selectedIndexes,
    });
  }

  @override
  Widget build(BuildContext context) {
    final positions =
        (widget.data['positions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final remaining = _requiredCards - _selectedIndexes.length;

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
                _isSubmitted
                    ? '已选定 $_requiredCards 张牌'
                    : _isShuffling
                    ? '正在洗牌...'
                    : '选择 $_requiredCards 张牌',
                style: textBoldLarge.copyWith(color: ColorResources.ink),
              ),
            ],
          ),
          if (!_isSubmitted && !_isShuffling) ...[
            const SizedBox(height: 4),
            Text(
              remaining > 0 ? '还需选择 $remaining 张' : '点击确认翻牌',
              style: textSmall.copyWith(color: ColorResources.muted),
            ),
          ],
          // Position hints
          if (positions.isNotEmpty && !_isSubmitted) ...[
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
          // Card fan
          AnimatedBuilder(
            animation: _shuffleAnimation,
            builder: (context, _) {
              return SizedBox(
                height: 160,
                child: Center(child: _buildCardFan()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardFan() {
    // Show cards in a fan/arc layout
    final displayCount = min(_totalCards, 12); // Show 12 cards in the fan
    final fanWidth = MediaQuery.of(context).size.width - 80;

    return SizedBox(
      width: fanWidth,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(displayCount, (i) {
          final isSelected = _selectedIndexes.contains(i);
          final normalizedIndex = i - (displayCount / 2);
          final angle = normalizedIndex * 0.08 * _shuffleAnimation.value;
          final xOffset =
              normalizedIndex *
              (fanWidth / displayCount) *
              0.7 *
              _shuffleAnimation.value;
          final yOffset =
              (normalizedIndex.abs() * 4.0) * _shuffleAnimation.value;

          return AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            left: (fanWidth / 2) + xOffset - 28,
            top: yOffset + (isSelected ? -12 : 8),
            child: GestureDetector(
              onTap: () => _onCardTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Transform.rotate(
                  angle: angle,
                  child: _buildSingleCard(i, isSelected),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSingleCard(int index, bool isSelected) {
    return Container(
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
                  color: ColorResources.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
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
