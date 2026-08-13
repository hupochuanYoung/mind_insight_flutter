import 'package:flutter/material.dart';

import 'draw_invitation_widget.dart';
import 'card_shuffle_widget.dart';
import 'card_reveal_widget.dart';
import 'interpretation_widget.dart';
import 'plain_message_widget.dart';

/// Callback type for GenUI action buttons.
typedef GenUiActionCallback = void Function(
    String action, Map<String, dynamic> data);

/// Registry that maps `ui_view` values from the agent response to Flutter widgets.
///
/// The agent returns structured JSON with a `ui_view` field that determines
/// which interactive component to render in the chat.
class GenUiRegistry {
  const GenUiRegistry._();

  /// Build the appropriate widget for the given agent response data.
  ///
  /// [data] is the full parsed JSON from `Contents[].Text` — a Map containing
  /// `stage`, `ui_view`, `message`, `data`, `actions`, etc.
  ///
  /// [onAction] is called when user taps an action button (e.g. "start_draw").
  static Widget build({
    required Map<String, dynamic> data,
    required GenUiActionCallback onAction,
  }) {
    final uiView = data['ui_view'] as String? ?? '';

    return switch (uiView) {
      'plain_message' => PlainMessageWidget(data: data),
      'clarify_question' => PlainMessageWidget(data: data),
      'draw_invitation' => DrawInvitationWidget(
          data: data,
          onAction: onAction,
        ),
      'card_shuffle' => CardShuffleWidget(
          data: data,
          onAction: onAction,
        ),
      'card_reveal' => CardRevealWidget(data: data, onAction: onAction),
      'interpretation' => InterpretationWidget(
          data: data,
          onAction: onAction,
        ),
      _ => PlainMessageWidget(data: data),
    };
  }
}
