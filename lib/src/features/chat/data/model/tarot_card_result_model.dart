class TarotCardResultModel {
  final String slot;
  final String card;
  final String orientation;

  const TarotCardResultModel({
    required this.slot,
    required this.card,
    required this.orientation,
  });

  /// Whether the card is drawn in reversed position.
  bool get isReversed => orientation == 'reversed';

  factory TarotCardResultModel.fromJson(Map<String, dynamic> json) {
    return TarotCardResultModel(
      slot: json['slot'] as String? ?? '',
      card: json['card'] as String? ?? '',
      orientation: json['orientation'] as String? ?? 'upright',
    );
  }
}
