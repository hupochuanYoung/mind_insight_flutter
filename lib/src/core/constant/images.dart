/// Asset path constants for MindInsight.
///
/// Centralizes all image/asset references so they are easy to find and rename.
class Images {
  const Images._();

  // ---------------------------------------------------------------------------
  // Tarot card assets
  // ---------------------------------------------------------------------------
  static const String tarotBasePath = 'assets/tarot';

  /// Return the tarot card asset path by card name.
  static String tarotCard(String cardName) => '$tarotBasePath/$cardName.png';

  // ---------------------------------------------------------------------------
  // Icons / illustrations (add as needed)
  // ---------------------------------------------------------------------------
  // static const String logo = 'assets/images/logo.png';
  // static const String emptyState = 'assets/images/empty.svg';
}
