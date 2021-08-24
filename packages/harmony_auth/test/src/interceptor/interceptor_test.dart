import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/checker/checker.dart';
import 'package:harmony_auth/src/interceptor/impl/impl.dart';
import 'package:harmony_auth/src/interceptor/interceptor.dart';
import 'package:harmony_auth/src/manipulator/manipulator.dart';
import 'package:harmony_auth/src/matcher/matcher.dart';
import 'package:harmony_auth/src/repository/repository.dart';
import 'package:harmony_auth/src/rest/rest.dart';
import 'package:harmony_auth/src/storage/storage.dart';
import 'package:harmony_auth/src/token/token.dart';
import 'package:mocktail/mocktail.dart';

const keyRetry = 'harmony_auth_retry';

const baseUrl = 'https://base/test';

const nonMatchingUrl = 'https://non_matching';

const testUrl = 'https://base/test';

const refreshUrl = 'https://base/refresh';

final token1 = AuthToken(refresh: 'r1', access: 'a1');

final token2 = AuthToken(refresh: 'r2', access: 'a2');

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeResponse extends Fake implements Response<dynamic> {}

class OtherError implements Exception {}

class MockAdapter extends Mock implements HttpClientAdapter {}

void main() {
  group('AuthException', () {
    group('standard', () {
      test('initialization', () {
        final e = AuthExceptionStandardImpl();
        expect(e, isA<AuthException>());
        expect(
          e.toString(),
          stringContainsInOrder(['AuthException', 'standard']),
        );
      });
    });
  });

  group('AuthDioErrorExtensions', () {
    test('isAuthException', () {
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.other,
          error: AuthExceptionStandardImpl(),
        ).isAuthException,
        isTrue,
      );
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.response,
          error: AuthExceptionStandardImpl(),
        ).isAuthException,
        isFalse,
      );
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.other,
          error: AssertionError(),
        ).isAuthException,
        isFalse,
      );
    });
  });

  group('AuthInterceptor', () {
    group('standard', () {
      late Dio dio;
      late MockAdapter adapter;
      late AuthRest rest;
      late AuthStorage storage;
      late AuthRepository repository;
      late AuthInterceptor interceptor;

      setUp(() {
        registerFallbackValue(FakeRequestOptions());
        adapter = MockAdapter();
        dio = Dio()..httpClientAdapter = adapter;
        rest = AuthRest(
          checker: AuthChecker(),
          refreshUrl: refreshUrl,
          dio: dio,
        );
        storage = AuthStorage.inMemory();
        repository = AuthRepository(
          storage: storage,
          rest: rest,
        );
        interceptor = AuthInterceptor(
          dio: dio,
          matcher: AuthMatcher.baseUrl(baseUrl),
          checker: AuthChecker(),
          manipulator: AuthManipulator(),
          repository: repository,
        );
        dio.interceptors.add(interceptor);

        when(() => adapter.fetch(any(), any(), any())).thenAnswer((inv) async {
          final r = inv.positionalArguments[0] as RequestOptions;
          print(r.uri);
          print(r.method);
          print(r.headers);
          print(r.extra);
          throw Exception('not implemented');
        });
      });

      tearDown(() {
        resetMocktailState();
      });

      group('non-matching', () {
        test('success', () async {
          await storage.setToken(token1);

          when(() => adapter.fetch(
                any(
                  that: predicate((RequestOptions request) =>
                      request.path == nonMatchingUrl &&
                      request.method == 'GET' &&
                      request.headers['authorization'] == null),
                ),
                any(),
                any(),
              )).thenAnswer((_) async => ResponseBody(
                Stream.empty(),
                200,
              ));

          await dio.get<dynamic>(nonMatchingUrl);
        });

        test('fail network', () async {
          await storage.setToken(token1);

          when(() => adapter.fetch(
                any(
                  that: predicate((RequestOptions request) =>
                      request.path == nonMatchingUrl &&
                      request.method == 'GET' &&
                      request.headers['authorization'] == null),
                ),
                any(),
                any(),
              )).thenAnswer((inv) async => throw OtherError());

          expect(
            () async => await dio.get<dynamic>(nonMatchingUrl),
            throwsA(
              predicate((DioError e) =>
                  e.type == DioErrorType.other && e.error is OtherError),
            ),
          );
        });
      });

      group('matching', () {
        test(
          '-token',
          () async {
            expect(
              () async => await dio.get<dynamic>(testUrl),
              throwsA(
                predicate((DioError e) =>
                    e.type == DioErrorType.other && e.error is AuthException),
              ),
            );
          },
        );

        test(
          '+token -> success',
          () async {
            await storage.setToken(token1);

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == testUrl &&
                        request.method == 'GET' &&
                        request.headers['authorization'] == 'Bearer a1' &&
                        request.extra[keyRetry] == null),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  200,
                ));

            await dio.get<dynamic>(testUrl);

            expect(await storage.getToken(), equals(token1));
          },
        );

        test(
          '+token -> network fail',
          () async {
            await storage.setToken(token1);

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == testUrl &&
                        request.method == 'GET' &&
                        request.headers['authorization'] == 'Bearer a1' &&
                        request.extra[keyRetry] == null),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => throw OtherError());

            expect(
              () async {
                try {
                  await dio.get<dynamic>(testUrl);
                } finally {
                  expect(await storage.getToken(), equals(token1));
                }
              },
              throwsA(
                predicate((DioError e) =>
                    e.type == DioErrorType.other && e.error is OtherError),
              ),
            );
          },
        );

        test(
          '+token -> auth fail -> (refresh: success) -> retry -> success',
          () async {
            await storage.setToken(token1);

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == testUrl &&
                        request.method == 'GET' &&
                        request.headers['authorization'] == 'Bearer a1' &&
                        request.extra[keyRetry] == null),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  401,
                ));

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == refreshUrl &&
                        request.method == 'POST' &&
                        request.headers['authorization'] == null &&
                        request.data['refresh'] == 'r1'),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.fromIterable([
                    Uint8List.fromList(
                      utf8.encode(
                        '{"refresh":"r2", "access":"a2"}',
                      ),
                    ),
                  ]),
                  200,
                  headers: {
                    'content-type': ['application/json'],
                    'accept': ['application/json'],
                  },
                ));

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == testUrl &&
                        request.method == 'GET' &&
                        request.headers['authorization'] == 'Bearer a2' &&
                        request.extra[keyRetry] != null),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  200,
                ));

            await dio.get<dynamic>(testUrl);

            expect(await storage.getToken(), equals(token2));
          },
        );

        test(
          '+token -> auth fail -> (refresh: success) -> retry -> network fail',
          () async {
            await storage.setToken(token1);

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == testUrl &&
                        request.method == 'GET' &&
                        request.headers['authorization'] == 'Bearer a1' &&
                        request.extra[keyRetry] == null),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  401,
                ));

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == refreshUrl &&
                        request.method == 'POST' &&
                        request.headers['authorization'] == null &&
                        request.data['refresh'] == 'r1'),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.fromIterable([
                    Uint8List.fromList(
                      utf8.encode(
                        '{"refresh":"r2", "access":"a2"}',
                      ),
                    ),
                  ]),
                  200,
                  headers: {
                    'content-type': ['application/json'],
                    'accept': ['application/json'],
                  },
                ));

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == testUrl &&
                        request.method == 'GET' &&
                        request.headers['authorization'] == 'Bearer a2' &&
                        request.extra[keyRetry] != null),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => throw OtherError());

            expect(
              () async {
                try {
                  await dio.get<dynamic>(testUrl);
                } finally {
                  expect(await storage.getToken(), equals(token2));
                }
              },
              throwsA(
                predicate((DioError e) =>
                    e.type == DioErrorType.other && e.error is OtherError),
              ),
            );
          },
        );

        test(
          '+token -> auth fail -> (refresh: success) -> retry -> auth fail',
          () async {
            await storage.setToken(token1);

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == testUrl &&
                        request.method == 'GET' &&
                        request.headers['authorization'] == 'Bearer a1' &&
                        request.extra[keyRetry] == null),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  401,
                ));

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == refreshUrl &&
                        request.method == 'POST' &&
                        request.headers['authorization'] == null &&
                        request.data['refresh'] == 'r1'),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.fromIterable([
                    Uint8List.fromList(
                      utf8.encode(
                        '{"refresh":"r2", "access":"a2"}',
                      ),
                    ),
                  ]),
                  200,
                  headers: {
                    'content-type': ['application/json'],
                    'accept': ['application/json'],
                  },
                ));

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == testUrl &&
                        request.method == 'GET' &&
                        request.headers['authorization'] == 'Bearer a2' &&
                        request.extra[keyRetry] != null),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  401,
                ));

            expect(
              () async {
                try {
                  await dio.get<dynamic>(testUrl);
                } finally {
                  expect(await storage.getToken(), equals(token2));
                }
              },
              throwsA(
                predicate((DioError e) =>
                    e.type == DioErrorType.other &&
                    e.error is Exception &&
                    e.error.toString().contains('too many retries')),
              ),
            );
          },
        );

        test(
          '+token -> auth fail -> (refresh: network fail)',
          () async {
            await storage.setToken(token1);

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == testUrl &&
                        request.method == 'GET' &&
                        request.headers['authorization'] == 'Bearer a1' &&
                        request.extra[keyRetry] == null),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  401,
                ));

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == refreshUrl &&
                        request.method == 'POST' &&
                        request.headers['authorization'] == null &&
                        request.data['refresh'] == 'r1'),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => throw OtherError());

            expect(
              () async {
                try {
                  await dio.get<dynamic>(testUrl);
                } finally {
                  expect(await storage.getToken(), equals(token1));
                }
              },
              throwsA(
                predicate((DioError e) =>
                    e.type == DioErrorType.other && e.error is OtherError),
              ),
            );
          },
        );

        test(
          '+token -> auth fail -> (refresh: auth fail)',
          () async {
            await storage.setToken(token1);

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == testUrl &&
                        request.method == 'GET' &&
                        request.headers['authorization'] == 'Bearer a1' &&
                        request.extra[keyRetry] == null),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  401,
                ));

            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == refreshUrl &&
                        request.method == 'POST' &&
                        request.headers['authorization'] == null &&
                        request.data['refresh'] == 'r1'),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  401,
                ));

            expect(
              () async {
                try {
                  await dio.get<dynamic>(testUrl);
                } finally {
                  expect(await storage.getToken(), isNull);
                }
              },
              throwsA(
                predicate((DioError e) =>
                    e.type == DioErrorType.other && e.error is AuthException),
              ),
            );
          },
        );
      });
    });
  });
}
