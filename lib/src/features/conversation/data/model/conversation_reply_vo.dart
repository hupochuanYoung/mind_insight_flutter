class ConversationReplyVO {
  final String userContent;
  final String assistantContent;

  const ConversationReplyVO({
    required this.userContent,
    required this.assistantContent,
  });

  factory ConversationReplyVO.fromJson(Map<String, dynamic> json) {
    return ConversationReplyVO(
      userContent: json['userContent'] as String? ?? '',
      assistantContent: json['assistantContent'] as String? ?? '',
    );
  }
}
