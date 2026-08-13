class AgentChatRequest {
  final int? conversationId;
  final String? agentType;
  final String? title;
  final String message;

  const AgentChatRequest({
    this.conversationId,
    this.agentType,
    this.title,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
        if (conversationId != null) 'conversationId': conversationId,
        if (agentType != null) 'agentType': agentType,
        if (title != null) 'title': title,
        'message': message,
      };
}
