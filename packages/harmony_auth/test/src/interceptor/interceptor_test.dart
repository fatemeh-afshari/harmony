import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_auth/src/exception/exception.dart';
import 'package:harmony_auth/src/rest/impl/rest.dart';
import 'package:harmony_auth/src/rest/model/token_pair.dart';
import 'package:harmony_auth/src/rest/rest.dart';
import 'package:harmony_auth/src/interceptor/interceptor.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/logger.dart';
import '../../utils/storage.dart';

class MockAdapter extends Mock implements HttpClientAdapter {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  group('AuthInterceptor', () {
    late MockAdapter adapter;
    late AuthStorage storage;
    late Dio dio;

    group('not matching call', () {
      setUp(() {
        registerFallbackValue(FakeRequestOptions());
        adapter = MockAdapter();
        when(() => adapter.close()).thenAnswer((_) {});
        storage = InMemoryAuthStorage();
        dio = Dio();
        dio.httpClientAdapter = adapter;
        dio.interceptors.add(AuthInterceptor(
          dio: dio,
          storage: storage,
          matcher: AuthMatcher.none(),
          rest: AuthRestImpl(
            dio: dio,
            refreshUrl: 'https://refresh',
            logger: noopLogger,
          ),
          logger: noopLogger,
        ));
      });

      tearDown(() {
        resetMocktailState();
      });

      test('when make request no token should be added', () async {
        await storage.setAccessToken('a1');
        await storage.setRefreshToken('r1');

        when(() => adapter.fetch(
              any(
                that: predicate((RequestOptions request) =>
                    request.headers['authorization'] == null),
              ),
              any(),
              any(),
            )).thenAnswer((_) async => ResponseBody(
              Stream.empty(),
              200,
            ));

        await dio.get<dynamic>('https://test');
      });
    });
  });
}
