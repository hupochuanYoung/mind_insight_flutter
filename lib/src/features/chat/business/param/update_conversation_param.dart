class UpdateConversationParam {
  final String title;

  const UpdateConversationParam({required this.title});

  Map<String, dynamic> toJson() => {
        'title': title,
      };
}
