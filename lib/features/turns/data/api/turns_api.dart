import 'dart:developer';

import 'package:cetis4/config/network/dio_client.dart';
import 'package:cetis4/features/turns/data/models/turns.dart';

class TurnApi {
  final DioClient _dioClient;

  TurnApi(this._dioClient);

  Future<List<TurnsModel>> getTurns() async {
    try {
      final res = await _dioClient.get('/turns');
      // Extract the data from the response
      final List<dynamic> careerDataList = res.data;
      // Convert the data into a list of TurnModel
      final List<TurnsModel> careers = careerDataList
          .map((careerData) => TurnsModel.fromMap(careerData))
          .toList();
      return careers;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
