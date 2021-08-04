import 'package:dio/dio.dart';

import '../matcher/matcher.dart';
import '../rest/rest.dart';
import '../storage/storage.dart';
import 'impl/standard.dart';

/// interceptor for harmony_auth module
abstract class AuthInterceptor implements Interceptor {
  /// standard implementation
  const factory AuthInterceptor.standard({
    required Dio dio,
    required AuthStorage storage,
    required AuthMatcher matcher,
    required AuthRest rest,
  }) = AuthInterceptorStandardImpl;
}
