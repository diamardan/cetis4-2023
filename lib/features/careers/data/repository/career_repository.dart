import 'package:cetis4/config/network/dio_exceptions.dart';
import 'package:cetis4/features/careers/data/api/career_api.dart';
import 'package:cetis4/features/careers/data/models/careers.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class CareerRepository {
  final CareerApi _api;

  CareerRepository(this._api);

  Future<List<CareerModel>> getCareers() async {
    try {
      final res = await _api.getCareers();
      return res; //(res).map((e) => CareerModel.fromJson(e as String)).toList();
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }
}
