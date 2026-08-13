class CreateConversationRequest {
  final String type;
  final String? title;

  const CreateConversationRequest({
    required this.type,
    this.title,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        if (title != null) 'title': title,
      };
}
