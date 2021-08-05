import 'package:dio/dio.dart';

import '../checker.dart';

/// standard checker
///
/// it will categorize only [401] status code with
/// error type of [DioErrorType.response] as unauthorized.\
///
/// note: it will ignore errors with null [DioError.response].
class AuthCheckerStandardImpl implements AuthChecker {
  const AuthCheckerStandardImpl();

  @override
  bool isUnauthorizedError(DioError error) =>
      error.type == DioErrorType.response && error.response?.statusCode == 401;
}
