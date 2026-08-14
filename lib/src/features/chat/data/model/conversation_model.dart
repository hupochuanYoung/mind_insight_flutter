class ConversationModel {
  final int id;
  final String conversationId;
  final String type;
  final String title;
  final String status;
  final String? lastMessagePreview;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ConversationModel({
    required this.id,
    required this.conversationId,
    required this.type,
    required this.title,
    required this.status,
    this.lastMessagePreview,
    this.createdAt,
    this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as int? ?? 0,
      conversationId: json['conversationId'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      lastMessagePreview: json['lastMessagePreview'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }
}
