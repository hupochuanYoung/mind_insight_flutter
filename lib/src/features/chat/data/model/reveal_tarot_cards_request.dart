class RevealTarotCardsRequest {
  final List<int> selectedIndexes;

  const RevealTarotCardsRequest({required this.selectedIndexes});

  Map<String, dynamic> toJson() => {
        'selectedIndexes': selectedIndexes,
      };
}
