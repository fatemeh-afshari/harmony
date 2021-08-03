import 'package:dio/dio.dart';

import '../exception/exception.dart';

/// extension methods to check if [DioError] was from
/// [AuthException] and extract the error.
///
/// If [AuthExceptions] happens [DioError] will have
/// [type] of [DioErrorType.other] and [error] of type
/// [AuthException].
extension AuthDioErrorExtensions on DioError {
  bool get isAuthException =>
      type == DioErrorType.other && error is AuthException;

  AuthException? get asAuthExceptionOrNull =>
      isAuthException ? error as AuthException : null;

  AuthException get asAuthException =>
      isAuthException ? error as AuthException : throw AssertionError();
}

/// transform an [AuthException] to [DioError].
extension AuthExceptionExtensions on AuthException {
  DioError toDioError(RequestOptions request) {
    return DioError(
      requestOptions: request,
      type: DioErrorType.other,
      response: null,
      error: this,
    );
  }
}
