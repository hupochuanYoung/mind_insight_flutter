import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/exception/api_error_handler.dart';
import '../../../../core/data/exception/failure.dart';
import '../../business/param/create_tarot_draw_param.dart';
import '../../business/param/reveal_tarot_cards_param.dart';
import '../model/tarot_reveal_model.dart';
import '../model/tarot_session_model.dart';

/// Remote data source for Tarot API.
class TarotRemoteDatasource {
  final DioClient _dioClient;

  TarotRemoteDatasource({required DioClient dioClient})
    : _dioClient = dioClient;

  Map<String, dynamic> _asJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  /// POST /api/tarot/draws
  Future<Either<Failure, TarotSessionModel>> createDraw(
    CreateTarotDrawParam param,
  ) async {
    try {
      final response = await _dioClient.post(
        AppConstants.tarotDrawsUri,
        data: param.toJson(),
      );
      final body = _asJsonMap(response.data);
      final code = body['code'] as int? ?? -1;
      if (code != 0) {
        return left(
          ServerFailure(
            errorMessage: body['message'] as String? ?? 'Unknown error',
            errorCode: code.toString(),
          ),
        );
      }
      return right(
        TarotSessionModel.fromJson(_asJsonMap(body['data'])),
      );
    } on DioException catch (e) {
      return left(
        ConnectionFailure(errorMessage: ApiErrorHandler.getMessage(e)),
      );
    } catch (e) {
      return left(
        ServerFailure(errorMessage: e.toString(), errorCode: 'UNKNOWN'),
      );
    }
  }

  /// GET /api/tarot/draws/{id}
  Future<Either<Failure, TarotSessionModel>> getDraw(int id) async {
    try {
      final response = await _dioClient.get(AppConstants.tarotDrawUri(id));
      final body = _asJsonMap(response.data);
      final code = body['code'] as int? ?? -1;
      if (code != 0) {
        return left(
          ServerFailure(
            errorMessage: body['message'] as String? ?? 'Unknown error',
            errorCode: code.toString(),
          ),
        );
      }
      return right(
        TarotSessionModel.fromJson(_asJsonMap(body['data'])),
      );
    } on DioException catch (e) {
      return left(
        ConnectionFailure(errorMessage: ApiErrorHandler.getMessage(e)),
      );
    } catch (e) {
      return left(
        ServerFailure(errorMessage: e.toString(), errorCode: 'UNKNOWN'),
      );
    }
  }

  /// POST /api/tarot/draws/{id}/reveal
  Future<Either<Failure, TarotRevealModel>> revealCards(
    int id,
    RevealTarotCardsParam param,
  ) async {
    try {
      final response = await _dioClient.post(
        AppConstants.tarotDrawRevealUri(id),
        data: param.toJson(),
      );
      final body = _asJsonMap(response.data);
      final code = body['code'] as int? ?? -1;
      if (code != 0) {
        return left(
          ServerFailure(
            errorMessage: body['message'] as String? ?? 'Unknown error',
            errorCode: code.toString(),
          ),
        );
      }
      return right(
        TarotRevealModel.fromJson(_asJsonMap(body['data'])),
      );
    } on DioException catch (e) {
      return left(
        ConnectionFailure(errorMessage: ApiErrorHandler.getMessage(e)),
      );
    } catch (e) {
      return left(
        ServerFailure(errorMessage: e.toString(), errorCode: 'UNKNOWN'),
      );
    }
  }

  /// POST /api/tarot/draws/{id}/interpret
  Future<Either<Failure, TarotRevealModel>> interpretCards(int id) async {
    try {
      final response = await _dioClient.post(
        AppConstants.tarotDrawInterpretUri(id),
      );
      final body = _asJsonMap(response.data);
      final code = body['code'] as int? ?? -1;
      if (code != 0) {
        return left(
          ServerFailure(
            errorMessage: body['message'] as String? ?? 'Unknown error',
            errorCode: code.toString(),
          ),
        );
      }
      return right(
        TarotRevealModel.fromJson(_asJsonMap(body['data'])),
      );
    } on DioException catch (e) {
      return left(
        ConnectionFailure(errorMessage: ApiErrorHandler.getMessage(e)),
      );
    } catch (e) {
      return left(
        ServerFailure(errorMessage: e.toString(), errorCode: 'UNKNOWN'),
      );
    }
  }
}
