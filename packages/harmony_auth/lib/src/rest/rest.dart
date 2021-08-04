import 'package:dio/dio.dart';

import '../matcher/matcher.dart';
import 'impl/standard.dart';

/// handle token refresh api calls for harmony_auth.
abstract class AuthRest {
  /// standard implementation.
  ///
  /// after sending refresh, server returns refresh and access.
  const factory AuthRest.standard({
    required Dio dio,
    required String refreshUrl,
  }) = AuthRestImpl;

  /// note: should ONLY throw DioError.
  /// other error will be of [type] [DioErrorType.other]
  /// and they will have [error] of type [AuthException]
  ///
  /// note: should NOT do anything other than making request,
  /// such as writing to storage ...
  ///
  /// note: this method should not have any side effects.
  Future<AuthRestToken> refreshTokens(String refresh);

  /// matcher to check to see if this call is to refresh tokens.
  AuthMatcher get refreshTokensMatcher;
}

/// access and refresh token pair returned from auth rest refresh operation
class AuthRestToken {
  /// refresh token
  final String refresh;

  /// access token
  final String access;

  const AuthRestToken({
    required this.refresh,
    required this.access,
  });
}
