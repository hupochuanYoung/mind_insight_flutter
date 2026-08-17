import 'tarot_card_result_model.dart';

class TarotSessionModel {
  final int id;
  final int conversationId;
  final String spreadType;
  final String? spreadName;
  final String question;
  final String? questionSummary;
  final String? topic;
  final String? guidance;
  final String? agentRecordId;
  final String? agentConversationId;
  final String? agentRelatedRecordId;
  final String? agentMessageId;
  final String? agentStage;
  final String? agentUiView;
  final String? agentLanguage;
  final bool allowReversed;
  final String status;
  final int requiredCards;
  final List<TarotCardResultModel> cards;
  final String? interpretation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TarotSessionModel({
    required this.id,
    required this.conversationId,
    required this.spreadType,
    this.spreadName,
    required this.question,
    this.questionSummary,
    this.topic,
    this.guidance,
    this.agentRecordId,
    this.agentConversationId,
    this.agentRelatedRecordId,
    this.agentMessageId,
    this.agentStage,
    this.agentUiView,
    this.agentLanguage,
    this.allowReversed = true,
    required this.status,
    required this.requiredCards,
    required this.cards,
    this.interpretation,
    this.createdAt,
    this.updatedAt,
  });

  factory TarotSessionModel.fromJson(Map<String, dynamic> json) {
    final cardsJson =
        (json['cards'] as List<dynamic>?)
            ?.whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        const <Map<String, dynamic>>[];
    return TarotSessionModel(
      id: json['id'] as int? ?? 0,
      conversationId: json['conversationId'] as int? ?? 0,
      spreadType: json['spreadType'] as String? ?? '',
      spreadName: json['spreadName'] as String?,
      question: json['question'] as String? ?? '',
      questionSummary: json['questionSummary'] as String?,
      topic: json['topic'] as String?,
      guidance: json['guidance'] as String?,
      agentRecordId: json['agentRecordId'] as String?,
      agentConversationId: json['agentConversationId'] as String?,
      agentRelatedRecordId: json['agentRelatedRecordId'] as String?,
      agentMessageId: json['agentMessageId'] as String?,
      agentStage: json['agentStage'] as String?,
      agentUiView: json['agentUiView'] as String?,
      agentLanguage: json['agentLanguage'] as String?,
      allowReversed: json['allowReversed'] as bool? ?? true,
      status: json['status'] as String? ?? 'created',
      requiredCards: json['requiredCards'] as int? ?? 1,
      cards: cardsJson.map(TarotCardResultModel.fromJson).toList(),
      interpretation: json['interpretation'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }
}
