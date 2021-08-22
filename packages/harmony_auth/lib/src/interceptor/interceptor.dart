import 'package:dio/dio.dart';

import '../checker/checker.dart';
import '../manipulator/manipulator.dart';
import '../matcher/matcher.dart';
import '../repository/repository.dart';
import 'impl/impl.dart';

/// interceptor for harmony_auth module
///
/// errors are only [DioError]s.
///
/// if auth exception occurs:
/// errors will only have [DioError.type] of [DioErrorType.other]
/// and they will have [error] of type [AuthException].
///
/// you can check if a [DioError] is related to auth
/// by using `.isAuthException` extension function.
///
/// you can convert [AuthException] to [DioError] using
/// `.toDioError(...)` extension function.
abstract class AuthInterceptor implements Interceptor {
  /// standard implementation
  const factory AuthInterceptor({
    required Dio dio,
    required AuthMatcher matcher,
    required AuthChecker checker,
    required AuthManipulator manipulator,
    required AuthRepository repository,
  }) = AuthInterceptorStandardImpl;
}
