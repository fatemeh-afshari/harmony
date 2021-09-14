import 'package:dio/dio.dart';
import 'package:harmony_login/src/result/result.dart';

/// social backend
class LoginSocial {
  final String baseUrl;
  final Dio dio;

  const LoginSocial({
    required this.baseUrl,
    required this.dio,
  });

  /// login
  Future<LoginResult> login({
    required String provider,
    required String email,
  }) async {
    throw UnimplementedError();
  }
}
