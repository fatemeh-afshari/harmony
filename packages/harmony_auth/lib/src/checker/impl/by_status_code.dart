import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../base/base.dart';

/// byStatusCodes checker
///
/// it will categorize only matched status codes as unauthorized.
///
/// note: it will ignore errors with null [DioError.response].
///
/// note: it will ignore error type of other than [DioErrorType.response].
///
/// note: it will ignore null status code.
@internal
class AuthCheckerByStatusCodeImpl extends AuthCheckerStatusCodeBase {
  final bool Function(int statusCode) statusCode;

  const AuthCheckerByStatusCodeImpl(this.statusCode);

  @override
  bool isUnauthorizedStatusCode(int statusCode) => this.statusCode(statusCode);
}
