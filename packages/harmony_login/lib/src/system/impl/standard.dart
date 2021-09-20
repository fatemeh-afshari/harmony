import 'package:dio/dio.dart';
import 'package:harmony_login/src/email_password/email_password.dart';
import 'package:harmony_login/src/email_password/impl/standard.dart';
import 'package:harmony_login/src/social/impl/standard.dart';
import 'package:harmony_login/src/social/social.dart';
import 'package:harmony_login/src/system/system.dart';
import 'package:meta/meta.dart';

/// harmony_login login system
@internal
class LoginSystemStandardImpl implements LoginSystem {
  /// like https://www.example.com/api/v1/hippo_shield/
  final String baseUrl;

  /// provide the same dio with your auth
  final Dio dio;

  const LoginSystemStandardImpl({
    required this.baseUrl,
    required this.dio,
  });

  /// email-password
  @override
  LoginEmailPassword emailPassword() => LoginEmailPasswordStandardImpl(
        baseUrl: baseUrl,
        dio: dio,
      );

  /// social
  @override
  LoginSocial social() => LoginSocialStandardImpl(
        baseUrl: baseUrl,
        dio: dio,
      );

  /// logout
  @override
  Future<void> logout() async {
    throw UnimplementedError();
  }

  /// this can be used to include/exclude urls on auth
  @override
  LoginUrls get urls => LoginUrls(
        included: {},
        excluded: {
          '${baseUrl}email_password_authentication/login/',
        },
      );
}
