import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/reveal_tarot_cards_request.dart';
import '../../data/model/tarot_reveal_model.dart';
import '../repository/chat_repository.dart';

/// Parameters for reveal — includes session id and selected indexes.
class RevealTarotCardsParams {
  final int tarotSessionId;
  final RevealTarotCardsRequest request;

  const RevealTarotCardsParams({
    required this.tarotSessionId,
    required this.request,
  });
}

/// Use case: reveal selected tarot cards.
class RevealTarotCardsUseCase
    extends UseCase<TarotRevealModel, RevealTarotCardsParams> {
  final ChatRepository _repository;

  RevealTarotCardsUseCase({required ChatRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, TarotRevealModel>> call(
    RevealTarotCardsParams params,
  ) {
    return _repository.revealTarotCards(params.tarotSessionId, params.request);
  }
}
