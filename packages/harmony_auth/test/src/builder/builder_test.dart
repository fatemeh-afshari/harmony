import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_auth/src/builder/impl/builder.dart';
import 'package:harmony_auth/src/interceptor/interceptor.dart';
import 'package:harmony_auth/src/matcher/matcher.dart';
import 'package:harmony_auth/src/rest/impl/rest.dart';
import 'package:harmony_auth/src/storage/impl/storage.dart';

import '../../utils/logger.dart';

void main() {
  group('AuthBuilder', () {
    test('storage', () {
      final matcher = AuthMatcher.all();
      final refreshUrl = 'https://refresh';
      final logger = noopLogger;
      final builder = AuthBuilder(
        refreshUrl: refreshUrl,
        matcher: matcher,
        logger: logger,
      ) as AuthBuilderImpl;
      expect(builder.logger, equals(logger));
      expect(builder.refreshUrl, equals(refreshUrl));
      expect(builder.matcher, equals(matcher));
      final storage = builder.storage as AuthStorageImpl;
      expect(storage.isInternal, isFalse);
      expect(storage.logger, equals(logger));
    });

    test('applyTo', () {
      final dio = Dio();
      final matcher = AuthMatcher.all();
      final refreshUrl = 'https://refresh';
      final logger = noopLogger;
      final builder = AuthBuilder(
        refreshUrl: refreshUrl,
        matcher: matcher,
        logger: logger,
      ) as AuthBuilderImpl;
      expect(builder.logger, equals(logger));
      expect(builder.refreshUrl, equals(refreshUrl));
      expect(builder.matcher, equals(matcher));
      builder.applyTo(dio);
      final interceptor = dio.interceptors.first as AuthInterceptor;
      expect(interceptor.logger, equals(logger));
      expect(interceptor.dio, equals(dio));
      expect(interceptor.matcher, equals(matcher));
      final storage = interceptor.storage as AuthStorageImpl;
      expect(storage.isInternal, isTrue);
      expect(storage.logger, equals(logger));
      final rest = interceptor.rest as AuthRestImpl;
      expect(rest.logger, equals(logger));
      expect(rest.refreshUrl, equals(refreshUrl));
      expect(rest.dio, equals(dio));
    });
  });
}
