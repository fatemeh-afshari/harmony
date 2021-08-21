import 'package:dio/dio.dart';

import '../checker/checker.dart';
import '../matcher/matcher.dart';
import 'impl/impl.dart';
import '../token/token.dart';

/// handle token refresh api calls for harmony_auth.
abstract class AuthRest {
  /// standard implementation.
  ///
  /// after sending refresh, server returns
  /// new refresh and new access tokens.
  const factory AuthRest({
    required Dio dio,
    required String refreshUrl,
    required AuthChecker checker,
  }) = AuthRestStandardImpl;

  /// accessOnly implementation.
  ///
  /// after sending refresh, server returns only
  /// new access token and refresh token remains the same.
  const factory AuthRest.accessOnly({
    required Dio dio,
    required String refreshUrl,
    required AuthChecker checker,
  }) = AuthRestAccessOnlyImpl;

  /// general implementation.
  ///
  /// provide matcher against refresh calls
  /// and a lambda to refresh tokens.
  const factory AuthRest.general({
    required Dio dio,
    required AuthMatcher refreshTokensMatcher,
    required Future<AuthToken> Function(Dio dio, String refresh) refresh,
  }) = AuthRestGeneralImpl;

  /// note: should ONLY throw [DioError] or [AuthException].
  /// [AuthException] is for when refresh token is invalidated.
  /// [DioError] is for other type of errors like when server is
  /// down or a socket exception occurs.
  ///
  /// note: should NOT do anything other than making request,
  /// such as writing to storage ...
  ///
  /// note: this method should not have any side effects.
  Future<AuthToken> refreshTokens(String refreshToken);

  /// matcher to check to see if this call is to refresh tokens.
  ///
  /// note: this should match exactly only refresh request.
  AuthMatcher get refreshTokensMatcher;
}
