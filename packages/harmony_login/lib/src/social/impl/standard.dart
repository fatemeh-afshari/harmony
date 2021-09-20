import 'package:dio/dio.dart';
import 'package:harmony_login/src/result/result.dart';
import 'package:harmony_login/src/social/social.dart';
import 'package:meta/meta.dart';

@internal
class LoginSocialStandardImpl implements LoginSocial {
  final String baseUrl;

  final Dio dio;

  const LoginSocialStandardImpl({
    required this.baseUrl,
    required this.dio,
  });

  @override
  Future<LoginResult> login({
    required String provider,
    required String email,
  }) async {
    throw UnimplementedError();
  }
}
