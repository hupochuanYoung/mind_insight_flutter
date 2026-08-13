class CreateMessageParam {
  final String content;

  const CreateMessageParam({required this.content});

  Map<String, dynamic> toJson() => {
        'content': content,
      };
}
