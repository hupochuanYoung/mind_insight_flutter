class AgentChatParam {
  final int? conversationId;
  final String? agentType;
  final String? title;
  final String? entryType;
  final String message;

  const AgentChatParam({
    this.conversationId,
    this.agentType,
    this.title,
    this.entryType,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
    if (conversationId != null) 'conversationId': conversationId,
    if (agentType != null) 'agentType': agentType,
    if (title != null) 'title': title,
    if (entryType != null) 'entryType': entryType,
    'message': message,
  };
}
