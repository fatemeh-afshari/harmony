import 'package:dio/dio.dart';

import 'impl/standard.dart';

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
  /// it will categorize only [401] status code with
  /// error type of [DioErrorType.response] as unauthorized.
  ///
  /// note: it will ignore errors with null [DioError.response].
  const factory AuthChecker.standard() = AuthCheckerStandardImpl;

  /// check to see if error is from unauthorized call
  bool isUnauthorizedError(DioError error);
}
