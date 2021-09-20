import 'package:dio/dio.dart';
import 'package:harmony_login/src/email_password/email_password.dart';
import 'package:harmony_login/src/result/result.dart';
import 'package:meta/meta.dart';

@internal
class LoginEmailPasswordStandardImpl implements LoginEmailPassword {
  final String baseUrl;

  final Dio dio;

  const LoginEmailPasswordStandardImpl({
    required this.baseUrl,
    required this.dio,
  });

  @override
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

  @override
  Future<LoginResult> register({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> resetPasswordVerifyCode({
    required String email,
    required String code,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<LoginResult> resetPasswordNewPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    throw UnimplementedError();
  }
}
