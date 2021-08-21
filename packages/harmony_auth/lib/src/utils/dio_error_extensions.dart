import 'package:dio/dio.dart';

import '../exception/exception.dart';

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
