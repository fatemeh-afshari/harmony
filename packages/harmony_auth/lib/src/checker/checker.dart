import 'package:dio/dio.dart';

import 'impl/impl.dart';

/// harmony_auth checker to check which [DioError]s are from
/// unauthorized calls.
///
/// note: calls should be matched using the provided
/// [AuthMatcher] beforehand. non-matched requests are
/// not checked for unauthorized responses.
///
/// note: only [DioErrors] are checked for being unauthorized,
/// if you have customized your [dio] please make sure
/// you haven't ignored unauthorized errors.
abstract class AuthChecker {
  /// standard checker
  ///
  /// it will categorize only [401] status code as unauthorized.
  ///
  /// note: it will ignore errors with null [DioError.response].
  ///
  /// note: it will ignore error type of other than [DioErrorType.response].
  ///
  /// note: it will ignore null status code.
  const factory AuthChecker() = AuthCheckerStandardImpl;

  /// statusCode checker
  ///
  /// it will categorize only given status code as unauthorized.
  ///
  /// note: it will ignore errors with null [DioError.response].
  ///
  /// note: it will ignore error type of other than [DioErrorType.response].
  ///
  /// note: it will ignore null status code.
  const factory AuthChecker.statusCode(
    int statusCode,
  ) = AuthCheckerStatusCodeImpl;

  /// statusCodes checker
  ///
  /// it will categorize only given status codes as unauthorized.
  ///
  /// note: it will ignore errors with null [DioError.response].
  ///
  /// note: it will ignore error type of other than [DioErrorType.response].
  ///
  /// note: it will ignore null status code.
  const factory AuthChecker.statusCodes(
    Set<int> statusCodes,
  ) = AuthCheckerStatusCodesImpl;

  /// byStatusCode checker
  ///
  /// it will categorize matched given status codes as unauthorized.
  ///
  /// note: it will ignore errors with null [DioError.response].
  ///
  /// note: it will ignore error type of other than [DioErrorType.response].
  ///
  /// note: it will ignore null status code.
  const factory AuthChecker.byStatusCode(
    bool Function(int statusCode) statusCode,
  ) = AuthCheckerByStatusCodeImpl;

  /// general checker
  ///
  /// you will provide a lambda which
  /// will check dio errors and return
  /// whether is an auth error or not.
  const factory AuthChecker.general(
    bool Function(DioError error) lambda,
  ) = AuthCheckerGeneralImpl;

  /// check to see if error is from unauthorized call
  bool isUnauthorizedError(DioError error);
}
