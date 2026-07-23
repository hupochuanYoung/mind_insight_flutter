import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';

/// Reusable text style constants following the POS app_text_styles pattern.
const TextStyle textRegular = TextStyle(
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w400,
);

const TextStyle textMedium = TextStyle(
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w500,
);

const TextStyle textBold = TextStyle(
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w700,
);

const TextStyle textSmall = TextStyle(
  fontSize: Dimensions.fontSizeSmall,
  fontWeight: FontWeight.w400,
);

const TextStyle textBoldSmall = TextStyle(
  fontSize: Dimensions.fontSizeSmall,
  fontWeight: FontWeight.w700,
);

const TextStyle textLarge = TextStyle(
  fontSize: Dimensions.fontSizeLarge,
  fontWeight: FontWeight.w500,
);

const TextStyle textBoldLarge = TextStyle(
  fontSize: Dimensions.fontSizeLarge,
  fontWeight: FontWeight.w700,
);

const TextStyle textExtraLarge = TextStyle(
  fontSize: Dimensions.fontSizeExtraLarge,
  fontWeight: FontWeight.w700,
);

const TextStyle textOverLarge = TextStyle(
  fontSize: Dimensions.fontSizeOverLarge,
  fontWeight: FontWeight.w700,
);

/// Muted text (secondary info).
TextStyle textMuted = textRegular.copyWith(color: ColorResources.muted);

/// Section header style.
TextStyle sectionHeaderStyle(ThemeData themeData) => textBoldSmall.copyWith(
  fontWeight: FontWeight.w700,
  letterSpacing: 0.8,
  color: themeData.hintColor,
);
