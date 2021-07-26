import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../matcher/matcher.dart';
import '../storage/storage.dart';
import 'impl/builder.dart';

abstract class AuthBuilder {
  const factory AuthBuilder({
    required Dio dio,
    required String baseUrl,
    required AuthMatcher matcher,
    required Logger logger,
  }) = AuthBuilderImpl;

  AuthStorage get storage;

  Interceptor get interceptor;
}
