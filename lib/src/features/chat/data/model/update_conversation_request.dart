class UpdateConversationRequest {
  final String title;

  const UpdateConversationRequest({required this.title});

  Map<String, dynamic> toJson() => {
        'title': title,
      };
}
