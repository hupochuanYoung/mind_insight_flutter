class ConversationMessageModel {
  final String messageId;
  final String? recordId;
  final String role;
  final String? type;
  final String content;
  final int? timestamp;

  const ConversationMessageModel({
    required this.messageId,
    required this.role,
    required this.content,
    this.recordId,
    this.type,
    this.timestamp,
  });

  factory ConversationMessageModel.fromJson(Map<String, dynamic> json) {
    return ConversationMessageModel(
      messageId: json['messageId'] as String? ?? '',
      recordId: json['recordId'] as String?,
      role: json['role'] as String? ?? '',
      type: json['type'] as String?,
      content: json['content'] as String? ?? '',
      timestamp: json['timestamp'] as int?,
    );
  }

  DateTime? get dateTime => timestamp != null
      ? DateTime.fromMillisecondsSinceEpoch(timestamp!)
      : null;
}
