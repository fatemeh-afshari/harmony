import 'package:dio/dio.dart';

import '../checker/checker.dart';
import '../matcher/matcher.dart';
import 'impl/impl.dart';

/// handle token refresh api calls for harmony_auth.
abstract class AuthRest {
  /// standard implementation.
  ///
  /// after sending refresh, server returns refresh and access.
  ///
  /// note: most of the time the same checker used for
  /// interceptor will suffice. and also most of the time
  /// standard checkers will suffice.
  const factory AuthRest.standard({
    required Dio dio,
    required String refreshUrl,
    required AuthChecker checker,
  }) = AuthRestStandardImpl;

  /// accessOnly implementation.
  ///
  /// after sending refresh, server returns only access token and
  /// refresh token remains the same.
  ///
  /// note: most of the time the same checker used for
  /// interceptor will suffice. and also most of the time
  /// standard checkers will suffice.
  const factory AuthRest.accessOnly({
    required Dio dio,
    required String refreshUrl,
    required AuthChecker checker,
  }) = AuthRestAccessOnlyImpl;

  /// general implementation.
  ///
  /// provide matcher and lambda to refresh tokens.
  const factory AuthRest.general({
    required Dio dio,
    required AuthMatcher refreshTokensMatcher,
    required Future<AuthRestToken> Function(Dio dio, String refresh) lambda,
  }) = AuthRestGeneralImpl;

  /// wrap an AuthRest with lock
  ///
  /// It enables concurrency support for rest
  factory AuthRest.withLock(AuthRest rest) = AuthRestWithLockImpl;

  /// note: should ONLY throw DioError.
  /// other error will be of [type] [DioErrorType.other]
  /// and they will have [error] of type [AuthException]
  ///
  /// You can convert [AuthException] to [DioError] using
  /// `.toDioError(...)` extension function.
  ///
  /// note: should NOT do anything other than making request,
  /// such as writing to storage ...
  ///
  /// note: this method should not have any side effects.
  Future<AuthRestToken> refreshTokens(String refresh);

  /// matcher to check to see if this call is to refresh tokens.
  ///
  /// note: this should match exactly only refresh request.
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

/// extensions for applying concurrency to AuthRest
extension AuthRestExt on AuthRest {
  /// wrap an AuthRest with lock
  ///
  /// It enables concurrency support for rest
  AuthRest wrapWithLock() => AuthRest.withLock(this);
}
