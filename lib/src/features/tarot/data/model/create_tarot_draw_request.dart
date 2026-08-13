class CreateTarotDrawRequest {
  final int conversationId;
  final String question;
  final String? questionSummary;
  final String? topic;
  final String spreadType;
  final String? spreadName;
  final int? requiredCards;
  final String? guidance;
  final List<String> positions;
  final bool allowReversed;
  final String? agentRecordId;
  final String? agentConversationId;
  final String? agentRelatedRecordId;
  final String? agentMessageId;
  final String? agentStage;
  final String? agentUiView;
  final String? agentLanguage;
  final List<dynamic>? agentActions;
  final Map<String, dynamic>? agentText;

  const CreateTarotDrawRequest({
    required this.conversationId,
    required this.question,
    this.questionSummary,
    this.topic,
    required this.spreadType,
    this.spreadName,
    this.requiredCards,
    this.guidance,
    required this.positions,
    this.allowReversed = true,
    this.agentRecordId,
    this.agentConversationId,
    this.agentRelatedRecordId,
    this.agentMessageId,
    this.agentStage,
    this.agentUiView,
    this.agentLanguage,
    this.agentActions,
    this.agentText,
  });

  Map<String, dynamic> toJson() => {
        'conversationId': conversationId,
        'question': question,
        if (questionSummary != null) 'questionSummary': questionSummary,
        if (topic != null) 'topic': topic,
        'spreadType': spreadType,
        if (spreadName != null) 'spreadName': spreadName,
        if (requiredCards != null) 'requiredCards': requiredCards,
        if (guidance != null) 'guidance': guidance,
        'positions': positions,
        'allowReversed': allowReversed,
        if (agentRecordId != null) 'agentRecordId': agentRecordId,
        if (agentConversationId != null)
          'agentConversationId': agentConversationId,
        if (agentRelatedRecordId != null)
          'agentRelatedRecordId': agentRelatedRecordId,
        if (agentMessageId != null) 'agentMessageId': agentMessageId,
        if (agentStage != null) 'agentStage': agentStage,
        if (agentUiView != null) 'agentUiView': agentUiView,
        if (agentLanguage != null) 'agentLanguage': agentLanguage,
        if (agentActions != null) 'agentActions': agentActions,
        if (agentText != null) 'agentText': agentText,
      };
}
