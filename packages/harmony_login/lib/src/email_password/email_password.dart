import 'package:dio/dio.dart';
import 'package:harmony_login/src/result/result.dart';

/// email-password backend
class LoginEmailPassword {
  final String baseUrl;
  final Dio dio;

  const LoginEmailPassword({
    required this.baseUrl,
    required this.dio,
  });

  /// login
  Future<LoginResult> login(String email, String password) async {
    final response = await dio.post<dynamic>(
      '${baseUrl}email_password_authentication/login/',
      data: {
        'email': email,
        'password': password,
      },
    );
    final result = response.data as Map<String, dynamic>;
    return LoginResult(
      backend: 'email_password_authentication',
      refresh: result['email'] as String,
      access: result['password'] as String,
    );
  }
}
