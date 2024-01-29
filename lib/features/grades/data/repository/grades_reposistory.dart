import 'package:cetis4/config/network/dio_exceptions.dart';
import 'package:cetis4/features/grades/data/api/grades_api.dart';
import 'package:cetis4/features/grades/data/models/grades.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class GradeRepository {
  final GradeApi _api;

  GradeRepository(this._api);

  Future<List<GradesModel>> getGrades() async {
    try {
      final res = await _api.getGrades();
      return res; //(res).map((e) => GradeModel.fromJson(e as String)).toList();
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }
}
