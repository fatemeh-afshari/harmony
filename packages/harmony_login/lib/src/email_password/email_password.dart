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
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
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

  /// register
  Future<LoginResult> register({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  /// reset password
  Future<void> resetPassword({
    required String email,
  }) async {
    throw UnimplementedError();
  }

  /// change password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    throw UnimplementedError();
  }

  /// verify code
  Future<void> verifyCode({
    required String email,
    required String code,
  }) async {
    throw UnimplementedError();
  }

  /// set new password
  Future<LoginResult> newPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    throw UnimplementedError();
  }
}
