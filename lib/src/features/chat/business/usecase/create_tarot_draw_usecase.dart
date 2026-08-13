import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/create_tarot_draw_request.dart';
import '../../data/model/tarot_session_model.dart';
import '../repository/chat_repository.dart';

/// Use case: create a new tarot draw session.
class CreateTarotDrawUseCase
    extends UseCase<TarotSessionModel, CreateTarotDrawRequest> {
  final ChatRepository _repository;

  CreateTarotDrawUseCase({required ChatRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, TarotSessionModel>> call(
    CreateTarotDrawRequest params,
  ) {
    return _repository.createTarotDraw(params);
  }
}
