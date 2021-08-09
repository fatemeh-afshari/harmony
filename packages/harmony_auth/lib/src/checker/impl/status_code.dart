import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../base/base.dart';

/// statusCodes checker
///
/// it will categorize only given status code as unauthorized.
///
/// note: it will ignore errors with null [DioError.response].
///
/// note: it will ignore error type of other than [DioErrorType.response].
///
/// note: it will ignore null status code.
@internal
class AuthCheckerStatusCodeImpl extends AuthCheckerStatusCodeBase {
  final int statusCode;

  const AuthCheckerStatusCodeImpl(this.statusCode);

  @override
  bool isUnauthorizedStatusCode(int statusCode) =>
      statusCode == this.statusCode;
}
