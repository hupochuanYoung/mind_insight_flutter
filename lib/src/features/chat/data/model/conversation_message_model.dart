class ConversationMessageModel {
  final String messageId;
  final String role;
  final String content;
  final String? createdAt;
  final Map<String, dynamic>? rawProviderData;

  const ConversationMessageModel({
    required this.messageId,
    required this.role,
    required this.content,
    this.createdAt,
    this.rawProviderData,
  });

  factory ConversationMessageModel.fromJson(Map<String, dynamic> json) {
    return ConversationMessageModel(
      messageId: json['messageId'] as String? ?? '',
      role: json['role'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
      rawProviderData: json['rawProviderData'] as Map<String, dynamic>?,
    );
  }
}
