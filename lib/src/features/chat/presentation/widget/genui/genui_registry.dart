import 'package:flutter/material.dart';

import 'draw_invitation_widget.dart';
import 'card_shuffle_widget.dart';
import 'card_reveal_widget.dart';
import 'interpretation_widget.dart';
import 'plain_message_widget.dart';

/// Callback type for GenUI action buttons.
typedef GenUiActionCallback =
    void Function(Map<String, dynamic> action, Map<String, dynamic> data);

/// Registry that maps agent response `stage`/legacy `ui_view` values to widgets.
///
/// New protocol prefers `stage`; legacy responses may still use `ui_view`.
class GenUiRegistry {
  const GenUiRegistry._();

  static String surfaceKey(Map<String, dynamic> data) {
    final stage = data['stage'] as String? ?? '';
    if (stage.isNotEmpty) {
      return switch (stage) {
        'text_answer' => 'plain_message',
        'clarify_question' => 'clarify_question',
        'invite_draw' => 'draw_invitation',
        'card_shuffle' => 'card_shuffle',
        'draw_result_ready' => 'card_reveal',
        'interpretation' => 'interpretation',
        _ => 'plain_message',
      };
    }
    return data['ui_view'] as String? ?? 'plain_message';
  }

  static List<Map<String, dynamic>> actionList(Map<String, dynamic> data) {
    final rawActions = data['actions'];
    if (rawActions is List) {
      return rawActions
          .whereType<Map<String, dynamic>>()
          .map((action) => Map<String, dynamic>.from(action))
          .toList();
    }
    return const [];
  }

  /// Build the appropriate widget for the given agent response data.
  ///
  /// [data] is the full parsed JSON from `Contents[].Text` — a Map containing
  /// `stage`, `ui_view`, `message`, `data`, `actions`, etc.
  ///
  /// [onAction] is called when user taps an action button (e.g. "start_draw").
  /// When `data['_readOnly']` is true, action buttons are suppressed.
  static Widget build({
    required Map<String, dynamic> data,
    required GenUiActionCallback onAction,
  }) {
    final uiView = surfaceKey(data);
    final readOnly = data['_readOnly'] == true;

    // Strip actions for read-only historical messages so buttons don't render
    final effectiveData = readOnly
        ? (Map<String, dynamic>.from(data)..['actions'] = <Map<String, dynamic>>[])
        : data;

    return switch (uiView) {
      'plain_message' => PlainMessageWidget(data: effectiveData),
      'clarify_question' => PlainMessageWidget(data: effectiveData),
      'draw_invitation' => DrawInvitationWidget(
        data: effectiveData,
        onAction: onAction,
      ),
      'card_shuffle' => CardShuffleWidget(
        data: effectiveData,
        onAction: onAction,
      ),
      'card_reveal' => CardRevealWidget(
        data: effectiveData,
        onAction: onAction,
      ),
      'interpretation' => InterpretationWidget(
        data: effectiveData,
        onAction: onAction,
      ),
      _ => PlainMessageWidget(data: effectiveData),
    };
  }
}
