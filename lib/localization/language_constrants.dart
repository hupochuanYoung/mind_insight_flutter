import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orderonline_pos/localization/app_localization.dart';
import 'package:orderonline_pos/main.dart';

String? getTranslated(String? key, BuildContext context) {
  String? text = key;
  try {
    text = AppLocalization.of(context)!.translate(key);
  } catch (error) {
    // debugPrint('error --- $error');
  }
  return text;
}

String? translateKey(String? key) {
  String? text = key;
  try {
    text = AppLocalization.of(Get.context!)!.translate(key);
  } catch (error) {
    if (kDebugMode) {
      debugPrint('error --- $error');
    }
  }
  return text;
}
