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
class AuthCheckerStatusCodesImpl extends AuthCheckerStatusCodeBase {
  final Set<int> statusCodes;

  const AuthCheckerStatusCodesImpl(this.statusCodes);

  @override
  bool isUnauthorizedStatusCode(int statusCode) {
    for (final s in statusCodes) {
      if (statusCode == s) return true;
    }
    return false;
  }
}
