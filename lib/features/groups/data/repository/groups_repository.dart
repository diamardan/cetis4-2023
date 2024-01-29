import 'package:cetis4/config/network/dio_exceptions.dart';
import 'package:cetis4/features/groups/data/api/groups_api.dart';
import 'package:cetis4/features/groups/data/models/groups.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class GroupRepository {
  final GroupApi _api;

  GroupRepository(this._api);

  Future<List<GroupsModel>> getGroups() async {
    try {
      final res = await _api.getGroups();
      return res; //(res).map((e) => GroupModel.fromJson(e as String)).toList();
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }
}
