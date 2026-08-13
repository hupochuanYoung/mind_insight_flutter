class ConversationEventVO {
  final int id;
  final int conversationId;
  final String eventType;
  final String summary;
  final String? payloadJson;
  final DateTime? createdAt;

  const ConversationEventVO({
    required this.id,
    required this.conversationId,
    required this.eventType,
    required this.summary,
    this.payloadJson,
    this.createdAt,
  });

  factory ConversationEventVO.fromJson(Map<String, dynamic> json) {
    return ConversationEventVO(
      id: json['id'] as int? ?? 0,
      conversationId: json['conversationId'] as int? ?? 0,
      eventType: json['eventType'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      payloadJson: json['payloadJson'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}
