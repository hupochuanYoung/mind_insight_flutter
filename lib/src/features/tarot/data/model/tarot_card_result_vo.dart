class TarotCardResultVO {
  final String slot;
  final String card;
  final String orientation;

  const TarotCardResultVO({
    required this.slot,
    required this.card,
    required this.orientation,
  });

  /// Whether the card is drawn in reversed position.
  bool get isReversed => orientation == 'reversed';

  factory TarotCardResultVO.fromJson(Map<String, dynamic> json) {
    return TarotCardResultVO(
      slot: json['slot'] as String? ?? '',
      card: json['card'] as String? ?? '',
      orientation: json['orientation'] as String? ?? 'upright',
    );
  }
}
