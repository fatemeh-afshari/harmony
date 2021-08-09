import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../checker.dart';

/// note: it will ignore errors with null [DioError.response].
///
/// note: it will ignore error type of other than [DioErrorType.response].
///
/// note: it will ignore null status code.
@internal
abstract class AuthCheckerStatusCodeBase implements AuthChecker {
  const AuthCheckerStatusCodeBase();

  bool isUnauthorizedStatusCode(int statusCode);

  @override
  bool isUnauthorizedError(DioError error) {
    if (error.type == DioErrorType.response) {
      final response = error.response;
      if (response != null) {
        final statusCode = response.statusCode;
        if (statusCode != null) {
          return isUnauthorizedStatusCode(statusCode);
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
