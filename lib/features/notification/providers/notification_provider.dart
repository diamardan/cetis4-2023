import 'dart:convert';

import 'package:cetis4/config/shared_provider/shared_providers.dart';
import 'package:cetis4/features/notification/data/api/notification_api.dart';
import 'package:cetis4/features/notification/data/models/device.dart';
import 'package:cetis4/features/notification/data/repository/notification_repository.dart';
import 'package:cetis4/utils/key_value_storage_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationApiProvider = Provider<NotificationApi>((ref) {
  return NotificationApi(ref.read(dioClientProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.read(notificationApiProvider));
});

final saveTokenDeviceProvider = Provider<void>((ref) async {
  final keyValueStorageService = KeyValueStorageServiceImpl();
  final userId = await keyValueStorageService.getValue<String>('userId');
  final deviceId =
      await keyValueStorageService.getValue<String>('info.deviceId');
  final devicebrand =
      await keyValueStorageService.getValue<String>('info.brand');
  final deviceModel =
      await keyValueStorageService.getValue<String>('info.model');
  final deviceOs = await keyValueStorageService.getValue<String>('info.os');
  final deviceVersion =
      await keyValueStorageService.getValue<String>('info.version');
  final fcm = await keyValueStorageService.getValue<String>('fcm');
  print("hoasdasdada");
  debugPrint(fcm);
  Map<String, dynamic> device = {
    "deviceId": deviceId,
    "brand": devicebrand,
    "model": deviceModel,
    "os": deviceOs,
    "version": deviceVersion,
    "fcm_token": fcm
  };

  await ref
      .read(notificationRepositoryProvider)
      .saveDevice(userId!, Device.fromJson(device));
});
