class ConversationReplyModel {
  final String userContent;
  final String assistantContent;

  const ConversationReplyModel({
    required this.userContent,
    required this.assistantContent,
  });

  factory ConversationReplyModel.fromJson(Map<String, dynamic> json) {
    return ConversationReplyModel(
      userContent: json['userContent'] as String? ?? '',
      assistantContent: json['assistantContent'] as String? ?? '',
    );
  }
}
