import 'package:dio/dio.dart';
import 'package:harmony_login/src/email_password/email_password.dart';
import 'package:harmony_login/src/social/social.dart';

/// harmony_login login system
class LoginSystem {
  /// like https://www.example.com/api/v1/hippo_shield/
  final String baseUrl;

  /// provide the same dio with your auth
  final Dio dio;

  const LoginSystem({
    required this.baseUrl,
    required this.dio,
  });

  /// email-password
  LoginEmailPassword emailPassword() => LoginEmailPassword(
        baseUrl: baseUrl,
        dio: dio,
      );

  /// social
  LoginSocial social() => LoginSocial(
        baseUrl: baseUrl,
        dio: dio,
      );

  /// logout
  Future<void> logout() async {
    throw UnimplementedError();
  }

  /// this can be used to include/exclude urls on auth
  LoginUrls get urls => LoginUrls(
        included: {},
        excluded: {
          '${baseUrl}email_password_authentication/login/',
        },
      );
}

/// urls to include/exclude from auth
class LoginUrls {
  /// include this
  final Set<String> included;

  /// exclude this
  final Set<String> excluded;

  const LoginUrls({
    required this.included,
    required this.excluded,
  });
}
