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
  final DateTime? timestamp;

  const AgentChatModel({
    required this.recordId,
    required this.conversationId,
    required this.relatedRecordId,
    required this.messageId,
    required this.localConversationId,
    required this.messages,
    this.timestamp,
  });

  factory AgentChatModel.fromJson(
    Map<String, dynamic> json, {
    dynamic timestamp,
  }) {
    return AgentChatModel(
      recordId: json['RecordId'] as String? ?? '',
      conversationId: json['ConversationId'] as String? ?? '',
      relatedRecordId: json['RelatedRecordId'] as String? ?? '',
      messageId: json['MessageId'] as String? ?? '',
      localConversationId: json['LocalConversationId'] as int? ?? 0,
      messages: json['Messages'] as List<dynamic>? ?? [],
      timestamp: _parseTimestamp(timestamp),
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
