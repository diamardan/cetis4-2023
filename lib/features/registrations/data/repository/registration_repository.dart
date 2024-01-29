import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cetis4/config/network/dio_exceptions.dart';
import 'package:cetis4/features/profile/data/models/register.dart';
import 'package:cetis4/features/registrations/data/api/registration_api.dart';
import 'package:cetis4/features/registrations/data/models/create_registration_model.dart';
import 'package:dio/dio.dart';

class RegistrationRepository {
  final RegistrationApi _api;

  RegistrationRepository(this._api);

  Future<Registration> findRegistration(String curp) async {
    try {
      final res = await _api.findByCurp(curp);
      if (res == "") return Registration();
      return RegisterInfo.fromJson(res).registration;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw DioExceptions.timeout();
      } else {
        final errorMessage = DioExceptions.fromDioError(e);
        log(errorMessage.toString());
        rethrow;
      }
    } on SocketException {
      throw DioExceptions.timeout();
    }
  }

  insertRegistration(CreateRegistrationModel registration, File? photo,
      File? voucher, ByteData? firma) async {
    try {
      final res =
          await _api.insertRegistration(registration, photo, voucher, firma);
      if (res == null) return null;
      return res;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }
}
