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
  bool get hasStructuredInterpretation => interpretation is Map<String, dynamic>;

  /// Get interpretation as a Map if structured, otherwise null.
  Map<String, dynamic>? get interpretationMap =>
      interpretation is Map<String, dynamic>
          ? interpretation as Map<String, dynamic>
          : null;

  /// Get interpretation as plain text.
  String get interpretationText => interpretation?.toString() ?? '';

  factory TarotRevealModel.fromJson(Map<String, dynamic> json) {
    return TarotRevealModel(
      tarotSessionId: json['tarotSessionId'] as int? ?? 0,
      spreadType: json['spreadType'] as String? ?? '',
      status: json['status'] as String? ?? '',
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) =>
                  TarotCardResultModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      interpretation: json['interpretation'],
    );
  }
}
