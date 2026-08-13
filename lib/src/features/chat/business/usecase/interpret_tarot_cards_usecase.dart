import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/tarot_reveal_model.dart';
import '../repository/chat_repository.dart';

/// Use case: interpret revealed tarot cards.
class InterpretTarotCardsUseCase extends UseCase<TarotRevealModel, int> {
  final ChatRepository _repository;

  InterpretTarotCardsUseCase({required ChatRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, TarotRevealModel>> call(int params) {
    return _repository.interpretTarotCards(params);
  }
}
