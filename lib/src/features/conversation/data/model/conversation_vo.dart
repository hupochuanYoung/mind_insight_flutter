class ConversationVO {
  final int id;
  final String conversationNo;
  final String type;
  final String title;
  final String status;
  final String? lastMessagePreview;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? rawProviderData;

  const ConversationVO({
    required this.id,
    required this.conversationNo,
    required this.type,
    required this.title,
    required this.status,
    this.lastMessagePreview,
    this.createdAt,
    this.updatedAt,
    this.rawProviderData,
  });

  factory ConversationVO.fromJson(Map<String, dynamic> json) {
    return ConversationVO(
      id: json['id'] as int? ?? 0,
      conversationNo: json['conversationNo'] as String? ?? '',
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
      rawProviderData: json['rawProviderData'] as Map<String, dynamic>?,
    );
  }
}
