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
      type == DioErrorType.other && error is AuthException
          ? error as AuthException
          : null;
}
