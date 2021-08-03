import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../interceptor/interceptor.dart';
import '../../matcher/matcher.dart';
import '../../rest/impl/rest.dart';
import '../../storage/impl/storage.dart';
import '../../storage/storage.dart';
import '../builder.dart';

@internal
@immutable
class AuthBuilderImpl implements AuthBuilder {
  final String refreshUrl;

  final AuthMatcher matcher;

  final Logger logger;

  const AuthBuilderImpl({
    required this.refreshUrl,
    required this.matcher,
    required this.logger,
  });

  @override
  AuthStorage get storage {
    return AuthStorageImpl(
      logger: logger,
      isInternal: false,
    );
  }

  @override
  void applyTo(final Dio dio) {
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        logger: logger,
        storage: AuthStorageImpl(
          logger: logger,
          isInternal: true,
        ),
        rest: AuthRestImpl(
          dio: dio,
          refreshUrl: refreshUrl,
          logger: logger,
        ),
        matcher: matcher,
      ),
    );
  }
}
