import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';

/// Renders a simple text bubble for `ui_view: plain_message` or `clarify_question`.
///
/// Shows the `message` field from the agent response.
class PlainMessageWidget extends StatelessWidget {
  const PlainMessageWidget({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final message = data['message'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorResources.border),
      ),
      child: Text(
        message,
        style: textRegular.copyWith(
          color: ColorResources.ink,
          height: 1.5,
        ),
      ),
    );
  }
}
