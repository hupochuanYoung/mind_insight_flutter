import 'tarot_card_result_model.dart';

/// Response model from the reveal/interpret endpoints.
class TarotRevealModel {
  final int tarotSessionId;
  final String spreadType;
  final String status;
  final List<TarotCardResultModel> cards;
  final dynamic interpretation;

  const TarotRevealModel({
    required this.tarotSessionId,
    required this.spreadType,
    required this.status,
    required this.cards,
    this.interpretation,
  });

  /// Whether interpretation is a structured object (JSON map).
  bool get hasStructuredInterpretation => interpretation is Map;

  /// Get interpretation as a Map if structured, otherwise null.
  Map<String, dynamic>? get interpretationMap =>
      interpretation is Map
          ? Map<String, dynamic>.from(interpretation as Map)
          : null;

  /// Get interpretation as plain text.
  String get interpretationText => interpretation?.toString() ?? '';

  factory TarotRevealModel.fromJson(Map<String, dynamic> json) {
    final cardsJson =
        (json['cards'] as List<dynamic>?)
            ?.whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        const <Map<String, dynamic>>[];
    return TarotRevealModel(
      tarotSessionId: json['tarotSessionId'] as int? ?? 0,
      spreadType: json['spreadType'] as String? ?? '',
      status: json['status'] as String? ?? '',
      cards: cardsJson.map(TarotCardResultModel.fromJson).toList(),
      interpretation: json['interpretation'],
    );
  }
}
