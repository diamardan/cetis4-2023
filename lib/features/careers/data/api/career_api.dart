import 'dart:developer';

import 'package:cetis4/config/network/dio_client.dart';
import 'package:cetis4/features/careers/data/models/careers.dart';

class CareerApi {
  final DioClient _dioClient;

  CareerApi(this._dioClient);

  Future<List<CareerModel>> getCareers() async {
    try {
      final res = await _dioClient.get('/careers');
      // Extract the data from the response
      final List<dynamic> careerDataList = res.data;
      // Convert the data into a list of CareerModel
      final List<CareerModel> careers = careerDataList
          .map((careerData) => CareerModel.fromMap(careerData))
          .toList();
      return careers;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
