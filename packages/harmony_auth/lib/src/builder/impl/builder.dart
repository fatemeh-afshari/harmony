import 'package:dio/dio.dart';
import 'package:harmony_auth/src/interceptor/interceptor.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../storage/storage.dart';
import '../../storage/impl/storage.dart';
import '../../matcher/matcher.dart';
import '../builder.dart';

@internal
@immutable
class AuthBuilderImpl implements AuthBuilder {
  final Dio dio;

  final String refreshUrl;

  final AuthMatcher matcher;

  final Logger logger;

  const AuthBuilderImpl({
    required this.dio,
    required this.refreshUrl,
    required this.matcher,
    required this.logger,
  });

  @override
  AuthStorage get storage {
    return AuthStorageIml(
      logger: logger,
      isInternal: false,
    );
  }

  @override
  Interceptor get interceptor {
    return AuthInterceptor(
      refreshUrl: refreshUrl,
      dio: dio,
      logger: logger,
      storage: AuthStorageIml(
        logger: logger,
        isInternal: true,
      ),
      matcher: matcher,
    );
  }
}
