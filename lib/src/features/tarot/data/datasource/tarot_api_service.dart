import '../../../../core/constant/app_constants.dart';
import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/model/api_response.dart';
import '../model/create_tarot_draw_request.dart';
import '../model/reveal_tarot_cards_request.dart';
import '../model/tarot_reveal_vo.dart';
import '../model/tarot_session_vo.dart';

class TarotApiService {
  final DioClient _dioClient;

  TarotApiService(this._dioClient);

  /// POST /api/tarot/draws
  Future<ApiResponse<TarotSessionVO>> createDraw(
      CreateTarotDrawRequest request) async {
    final response = await _dioClient.post(
      AppConstants.tarotDrawsUri,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => TarotSessionVO.fromJson(json as Map<String, dynamic>),
    );
  }

  /// GET /api/tarot/draws/{id}
  Future<ApiResponse<TarotSessionVO>> getDraw(int id) async {
    final response = await _dioClient.get(
      AppConstants.tarotDrawUri(id),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => TarotSessionVO.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/tarot/draws/{id}/reveal
  Future<ApiResponse<TarotRevealVO>> revealCards(
      int id, RevealTarotCardsRequest request) async {
    final response = await _dioClient.post(
      AppConstants.tarotDrawRevealUri(id),
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => TarotRevealVO.fromJson(json as Map<String, dynamic>),
    );
  }
}
