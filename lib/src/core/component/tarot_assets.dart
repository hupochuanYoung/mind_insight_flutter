class TarotAssets {
  const TarotAssets._();

  static const int totalCards = 78;

  static String card(int number) {
    final normalized = number.clamp(1, totalCards).toString().padLeft(2, '0');
    return 'assets/tarot/tarot_$normalized.jpeg';
  }

  static const List<String> sampleSpread = [
    'assets/tarot/tarot_14.jpeg',
    'assets/tarot/tarot_02.jpeg',
    'assets/tarot/tarot_19.jpeg',
  ];
}
