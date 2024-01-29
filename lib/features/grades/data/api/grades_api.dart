import 'dart:developer';

import 'package:cetis4/config/network/dio_client.dart';
import 'package:cetis4/features/grades/data/models/grades.dart';

class GradeApi {
  final DioClient _dioClient;

  GradeApi(this._dioClient);

  Future<List<GradesModel>> getGrades() async {
    try {
      final res = await _dioClient.get('/grades');
      // Extract the data from the response
      final List<dynamic> careerDataList = res.data;
      // Convert the data into a list of GradeModel
      final List<GradesModel> careers = careerDataList
          .map((careerData) => GradesModel.fromMap(careerData))
          .toList();
      return careers;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
