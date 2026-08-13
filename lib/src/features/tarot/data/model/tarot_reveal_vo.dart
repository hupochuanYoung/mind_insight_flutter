import 'tarot_card_result_vo.dart';

/// Response from the reveal endpoint.
///
/// [interpretation] can be either a parsed JSON object (Map) or a plain string,
/// depending on what the agent returns.
class TarotRevealVO {
  final int tarotSessionId;
  final String spreadType;
  final String status;
  final List<TarotCardResultVO> cards;
  final dynamic interpretation;

  const TarotRevealVO({
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

  factory TarotRevealVO.fromJson(Map<String, dynamic> json) {
    return TarotRevealVO(
      tarotSessionId: json['tarotSessionId'] as int? ?? 0,
      spreadType: json['spreadType'] as String? ?? '',
      status: json['status'] as String? ?? '',
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) =>
                  TarotCardResultVO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      interpretation: json['interpretation'],
    );
  }
}
