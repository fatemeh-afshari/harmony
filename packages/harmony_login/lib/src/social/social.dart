import 'package:dio/dio.dart';
import 'package:harmony_login/src/result/result.dart';
import 'package:meta/meta.dart';

/// social backend
class LoginSocial {
  @internal
  final String baseUrl;

  @internal
  final Dio dio;

  @internal
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
