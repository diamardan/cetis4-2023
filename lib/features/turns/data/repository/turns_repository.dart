import 'package:cetis4/config/network/dio_exceptions.dart';
import 'package:cetis4/features/turns/data/api/turns_api.dart';
import 'package:cetis4/features/turns/data/models/turns.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class TurnRepository {
  final TurnApi _api;

  TurnRepository(this._api);

  Future<List<TurnsModel>> getTurns() async {
    try {
      final res = await _api.getTurns();
      return res; //(res).map((e) => TurnModel.fromJson(e as String)).toList();
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }
}
