import 'package:dio/dio.dart';

import '../checker/checker.dart';
import '../manipulator/manipulator.dart';
import '../matcher/matcher.dart';
import '../repository/repository.dart';
import 'impl/impl.dart';

/// interceptor for harmony_auth module
///
/// errors are only [DioError]s.
///
/// if auth exception occurs:
/// errors will only have [DioError.type] of [DioErrorType.other]
/// and they will have [error] of type [AuthException].
///
/// you can check if a [DioError] is related to auth
/// by using `.isAuthException` extension function.
///
/// you can convert [AuthException] to [DioError] using
/// `.toDioError(...)` extension function.
abstract class AuthInterceptor implements Interceptor {
  /// standard implementation
  const factory AuthInterceptor({
    required Dio dio,
    required AuthMatcher matcher,
    required AuthChecker checker,
    required AuthManipulator manipulator,
    required AuthRepository repository,
  }) = AuthInterceptorStandardImpl;
}

/// harmony_auth interceptor exception.
///
/// If [AuthExceptions] happens [DioError] will have
/// [type] of [DioErrorType.other] and [error] of type
/// [AuthException].
///
/// You can use [isAuthException] extension function on
/// [DioError] to check if error is from auth exception.
///
/// When you get [AuthException], it means that
/// you should reauthenticate the current user and
/// no token is available.
///
/// [AuthException] is also used in [AuthRest] and [AuthRepository]
/// to indicate refresh errors due to invalid refresh tokens.
abstract class AuthException implements Exception {}

/// extension methods to check if [DioError] was from
/// [AuthException] and extract the error.
///
/// If [AuthExceptions] happens [DioError] will have
/// [type] of [DioErrorType.other] and [error] of type
/// [AuthException].
extension AuthDioErrorExt on DioError {
  bool get isAuthException =>
      type == DioErrorType.other && error is AuthException;
}
