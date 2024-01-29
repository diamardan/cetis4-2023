import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cetis4/config/network/dio_exceptions.dart';
import 'package:cetis4/features/registrations/data/models/create_registration_model.dart';
import 'package:cetis4/features/repositions/data/api/repositions_api.dart';
import 'package:dio/dio.dart';

class RepositionRepository {
  final RepositionApi _api;

  RepositionRepository(this._api);

  insertReposition(CreateRegistrationModel registration, File? photo,
      File? voucher, ByteData? firma) async {
    try {
      final res =
          await _api.insertReposition(registration, photo, voucher, firma);
      if (res == null) return null;
      return res;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }
}
