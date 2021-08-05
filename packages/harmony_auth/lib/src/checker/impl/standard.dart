import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../base/status_code.dart';

/// standard checker
///
/// it will categorize only [401] status code as unauthorized.
///
/// note: it will ignore errors with null [DioError.response].
///
/// note: it will ignore error type of other than [DioErrorType.response].
///
/// note: it will ignore null status code.
@internal
class AuthCheckerStandardImpl extends AuthCheckerStatusCodeBase {
  const AuthCheckerStandardImpl();

  @override
  bool isUnauthorizedStatusCode(int statusCode) => statusCode == 401;
}
