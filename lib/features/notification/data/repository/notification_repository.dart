import 'dart:developer';

import 'package:cetis4/config/network/dio_exceptions.dart';
import 'package:cetis4/features/notification/data/api/notification_api.dart';
import 'package:cetis4/features/notification/data/models/device.dart';
import 'package:dio/dio.dart';

class NotificationRepository {
  final NotificationApi _api;

  NotificationRepository(this._api);

  Future<void> saveDevice(String userId, Device device) async {
    try {
      await _api.saveDevice(userId, device);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }
}
