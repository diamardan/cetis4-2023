import 'dart:developer';

import 'package:cetis4/config/network/dio_client.dart';
import 'package:cetis4/features/groups/data/models/groups.dart';

class GroupApi {
  final DioClient _dioClient;

  GroupApi(this._dioClient);

  Future<List<GroupsModel>> getGroups() async {
    try {
      final res = await _dioClient.get('/groups');
      // Extract the data from the response
      final List<dynamic> careerDataList = res.data;
      // Convert the data into a list of GroupModel
      final List<GroupsModel> careers = careerDataList
          .map((careerData) => GroupsModel.fromMap(careerData))
          .toList();
      return careers;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
