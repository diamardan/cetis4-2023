import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http_parser/http_parser.dart';

import 'package:cetis4/config/network/dio_client.dart';
import 'package:cetis4/config/network/dio_exceptions.dart';
import 'package:cetis4/features/registrations/data/models/create_registration_model.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RepositionApi {
  // dio instance
  final DioClient _dioClient;
  final dio = Dio();

  // injecting dio instance
  RepositionApi(this._dioClient);

  Future<String> handleSignature(ByteData firma) async {
    final dir = await getTemporaryDirectory();
    final imgFirma = File(path.join(dir.path, 'student_signature.jpg'));
    List<int> uint8List = firma.buffer.asUint8List();

    await imgFirma.writeAsBytes(
      uint8List /*  firma.buffer.asUint8List(firma.offsetInBytes, firma.lengthInBytes) */,
    );
    log(imgFirma.path);
    return imgFirma.path;
  }

  Future insertReposition(CreateRegistrationModel registration, File? photo,
      File? voucher, ByteData? firma) async {
    try {
      String imgFirma = '';

      final formData = FormData.fromMap({
        'names': registration.names,
        'surnames': registration.surnames,
        'curp': registration.curp,
        'email': registration.email,
        'cellphone': registration.cellphone,
        'registration_type': registration.registrationType,
        'registration_number': registration.registrationNumber,
        'career': registration.career,
        'grade': registration.grade,
        'group': registration.group,
        'turn': registration.turn,
      });

      if (photo != null) {
        formData.files.add(MapEntry(
            'student_photo',
            await MultipartFile.fromFile(photo.path,
                filename: 'student_photo.jpg',
                contentType: MediaType('image', 'jpg'))));
      }

      if (voucher != null) {
        formData.files.add(MapEntry(
            'student_voucher',
            await MultipartFile.fromFile(voucher.path,
                filename: 'student_voucher.jpg',
                contentType: MediaType('image', 'jpg'))));
      }

      if (firma != null) {
        imgFirma = await handleSignature(firma);
        formData.files.add(MapEntry(
            'student_signature',
            await MultipartFile.fromFile(imgFirma,
                filename: 'student_signature.jpg',
                contentType: MediaType('image', 'jpg'))));
      }

      final res = await _dioClient.patch(
        '/repositions/${registration.id}',
        data: formData,
      );
      return res.data;
    } on DioException catch (e) {
      final dioError = DioExceptions.fromDioError(e);
      log(dioError.toString());
      rethrow;
    }
  }
}
