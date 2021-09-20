import 'package:dio/dio.dart';
import 'package:harmony_login/src/email_password/email_password.dart';
import 'package:harmony_login/src/social/social.dart';
import 'package:harmony_login/src/system/impl/standard.dart';

/// harmony_login login system
abstract class LoginSystem {
  /// standard impl
  const factory LoginSystem({
    required String baseUrl,
    required Dio dio,
  }) = LoginSystemStandardImpl;

  /// email-password
  LoginEmailPassword emailPassword();

  /// social
  LoginSocial social();

  /// logout
  Future<void> logout();

  /// this can be used to include/exclude urls on auth
  LoginUrls get urls;
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
