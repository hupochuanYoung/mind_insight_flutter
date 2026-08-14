import 'conversation_message_model.dart';

class ConversationMessageListModel {
  final List<ConversationMessageModel> messages;
  final String? firstRecordId;
  final String? lastRecordId;
  final bool hasMoreBefore;
  final bool hasMoreAfter;

  const ConversationMessageListModel({
    required this.messages,
    this.firstRecordId,
    this.lastRecordId,
    this.hasMoreBefore = false,
    this.hasMoreAfter = false,
  });

  factory ConversationMessageListModel.fromJson(Map<String, dynamic> json) {
    final list = (json['messages'] as List<dynamic>?)
            ?.map((e) => ConversationMessageModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return ConversationMessageListModel(
      messages: list,
      firstRecordId: json['firstRecordId'] as String?,
      lastRecordId: json['lastRecordId'] as String?,
      hasMoreBefore: json['hasMoreBefore'] as bool? ?? false,
      hasMoreAfter: json['hasMoreAfter'] as bool? ?? false,
    );
  }
}
