/// Response model from the agent chat endpoint.
///
/// Field names use PascalCase to match the backend JSON format (Tencent ADP).
class AgentChatModel {
  final String recordId;
  final String conversationId;
  final String relatedRecordId;
  final String messageId;
  final int localConversationId;
  final List<dynamic> messages;

  const AgentChatModel({
    required this.recordId,
    required this.conversationId,
    required this.relatedRecordId,
    required this.messageId,
    required this.localConversationId,
    required this.messages,
  });

  factory AgentChatModel.fromJson(Map<String, dynamic> json) {
    return AgentChatModel(
      recordId: json['RecordId'] as String? ?? '',
      conversationId: json['ConversationId'] as String? ?? '',
      relatedRecordId: json['RelatedRecordId'] as String? ?? '',
      messageId: json['MessageId'] as String? ?? '',
      localConversationId: json['LocalConversationId'] as int? ?? 0,
      messages: json['Messages'] as List<dynamic>? ?? [],
    );
  }
}
