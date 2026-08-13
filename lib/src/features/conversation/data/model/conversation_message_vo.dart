class ConversationMessageVO {
  final String messageId;
  final String role;
  final String content;
  final String? createdAt;
  final Map<String, dynamic>? rawProviderData;

  const ConversationMessageVO({
    required this.messageId,
    required this.role,
    required this.content,
    this.createdAt,
    this.rawProviderData,
  });

  factory ConversationMessageVO.fromJson(Map<String, dynamic> json) {
    return ConversationMessageVO(
      messageId: json['messageId'] as String? ?? '',
      role: json['role'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
      rawProviderData: json['rawProviderData'] as Map<String, dynamic>?,
    );
  }
}
