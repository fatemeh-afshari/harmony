import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../matcher/matcher.dart';
import '../storage/storage.dart';
import 'impl/builder.dart';

/// builder for harmony_auth module.
///
/// use it to build storage and interceptor.
/// use interceptor with [Dio], and use storage to
/// change token from outside.
abstract class AuthBuilder {
  const factory AuthBuilder({
    required String refreshUrl,
    required AuthMatcher matcher,
    required Logger logger,
  }) = AuthBuilderImpl;

  AuthStorage get storage;

  void applyTo(Dio dio);
}
