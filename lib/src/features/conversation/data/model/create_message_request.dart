class CreateMessageRequest {
  final String content;

  const CreateMessageRequest({required this.content});

  Map<String, dynamic> toJson() => {
        'content': content,
      };
}
