import 'package:cetis4/config/network/dio_client.dart';

class AuthApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AuthApi(this._dioClient);

  Future loginWithQr(String qr) async {
    try {
      final res = await _dioClient.post('/auth/qr', data: {'qrHash': qr});
      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        return res.data;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future loginWithCredentials(String email, String password) async {
    try {
      final res = await _dioClient
          .post('/auth/login', data: {'email': email, 'password': password});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
