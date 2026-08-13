import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/tarot_reveal_model.dart';
import '../param/reveal_tarot_cards_param.dart';
import '../repository/chat_repository.dart';

/// Use case: reveal selected tarot cards.
class RevealTarotCardsUseCase
    extends UseCase<TarotRevealModel, RevealTarotCardsParam> {
  final ChatRepository _repository;

  RevealTarotCardsUseCase({required ChatRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, TarotRevealModel>> call(RevealTarotCardsParam params) {
    return _repository.revealTarotCards(params.tarotSessionId, params);
  }
}
