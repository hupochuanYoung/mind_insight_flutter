import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Standard spacing, font size, and radius constants.
///
/// Mirrors the POS Dimensions class — single source of truth for layout values.
class Dimensions {
  const Dimensions._();

  // ---------------------------------------------------------------------------
  // Font sizes
  // ---------------------------------------------------------------------------
  static const double fontSizeExtraSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeDefault = 14.0;
  static const double fontSizeMedium = 15.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeExtraLarge = 18.0;
  static const double fontSizeOverLarge = 24.0;
  static const double fontSizeHuge = 32.0;

  // ---------------------------------------------------------------------------
  // Padding
  // ---------------------------------------------------------------------------
  static const double paddingSizeExtraSmall = 4.0;
  static const double paddingSizeSmall = 8.0;
  static const double paddingSizeDefault = 12.0;
  static const double paddingSizeMedium = 16.0;
  static const double paddingSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 24.0;
  static const double paddingSizeOverLarge = 32.0;

  // ---------------------------------------------------------------------------
  // Border radius
  // ---------------------------------------------------------------------------
  static const double radiusSmall = 4.0;
  static const double radiusDefault = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 24.0;
  static const double radiusCircular = 100.0;

  // ---------------------------------------------------------------------------
  // Screen helpers
  // ---------------------------------------------------------------------------
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
}

// ---------------------------------------------------------------------------
// Gap shortcuts (requires `gap` package)
// ---------------------------------------------------------------------------
const kGap2 = Gap(2);
const kGap4 = Gap(4);
const kGap6 = Gap(6);
const kGap8 = Gap(8);
const kGap10 = Gap(10);
const kGap12 = Gap(12);
const kGap16 = Gap(16);
const kGap20 = Gap(20);
const kGap24 = Gap(24);
const kGap32 = Gap(32);
const kGap40 = Gap(40);
const kGap48 = Gap(48);
