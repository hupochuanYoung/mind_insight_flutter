class CreateConversationParam {
  final String type;
  final String? title;

  const CreateConversationParam({
    required this.type,
    this.title,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        if (title != null) 'title': title,
      };
}
