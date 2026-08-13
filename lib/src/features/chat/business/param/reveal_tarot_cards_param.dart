class RevealTarotCardsParam {
  final int tarotSessionId;
  final List<int> selectedIndexes;

  const RevealTarotCardsParam({
    required this.tarotSessionId,
    required this.selectedIndexes,
  });

  Map<String, dynamic> toJson() => {
        'selectedIndexes': selectedIndexes,
      };
}
