import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_auth/src/exception/exception.dart';
import 'package:harmony_auth/src/interceptor/interceptor.dart';
import 'package:harmony_auth/src/rest/impl/rest.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/storage.dart';

const keyRetry = 'harmony_auth_is_retry';
const testUrl = 'https://test';
const refreshUrl = 'https://refresh';

class MockAdapter extends Mock implements HttpClientAdapter {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  group('AuthInterceptor', () {
    late MockAdapter adapter;
    late AuthStorage storage;
    late Dio dio;

    group('check refresh call is not matched anyway', () {
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
          matcher: AuthMatcher.all(),
          rest: AuthRestImpl(
            dio: dio,
            refreshUrl: refreshUrl,
          ),
        ));
      });

      tearDown(() {
        resetMocktailState();
      });

      test('when make refresh request no token should be added', () async {
        await storage.setAccessToken('a1');
        await storage.setRefreshToken('r1');

        when(() => adapter.fetch(
              any(
                that: predicate((RequestOptions request) =>
                    request.path == refreshUrl &&
                    request.method == 'POST' &&
                    request.headers['authorization'] == null),
              ),
              any(),
              any(),
            )).thenAnswer((_) async => ResponseBody(
              Stream.empty(),
              200,
            ));

        await dio.post<dynamic>(refreshUrl);
      });
    });

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
            refreshUrl: refreshUrl,
          ),
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
                    request.path == testUrl &&
                    request.method == 'GET' &&
                    request.headers['authorization'] == null),
              ),
              any(),
              any(),
            )).thenAnswer((_) async => ResponseBody(
              Stream.empty(),
              200,
            ));

        await dio.get<dynamic>(testUrl);
      });
    });

    group('matching call', () {
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
          matcher: AuthMatcher.all(),
          rest: AuthRestImpl(
            dio: dio,
            refreshUrl: refreshUrl,
          ),
        ));
      });

      tearDown(() {
        resetMocktailState();
      });

      test(
        'access -> success',
        () async {
          await storage.setAccessToken('a1');
          await storage.setRefreshToken('r1');

          when(() => adapter.fetch(
                any(
                  that: predicate((RequestOptions request) =>
                      request.path == testUrl &&
                      request.method == 'GET' &&
                      request.headers['authorization'] == 'bearer a1' &&
                      request.extra[keyRetry] == null),
                ),
                any(),
                any(),
              )).thenAnswer((_) async => ResponseBody(
                Stream.empty(),
                200,
              ));

          await dio.get<dynamic>(testUrl);

          expect(await storage.getAccessToken(), equals('a1'));
          expect(await storage.getRefreshToken(), equals('r1'));
        },
      );

      test(
        'access -> network fail',
        () async {
          await storage.setAccessToken('a1');
          await storage.setRefreshToken('r1');

          when(() => adapter.fetch(
                any(
                  that: predicate((RequestOptions request) =>
                      request.path == testUrl &&
                      request.method == 'GET' &&
                      request.headers['authorization'] == 'bearer a1' &&
                      request.extra[keyRetry] == null),
                ),
                any(),
                any(),
              )).thenAnswer((_) async => throw SocketException('error'));

          expect(
            () async {
              try {
                await dio.get<dynamic>(testUrl);
              } finally {
                expect(await storage.getAccessToken(), equals('a1'));
                expect(await storage.getRefreshToken(), equals('r1'));
              }
            },
            throwsA(
              predicate((DioError e) =>
                  e.type == DioErrorType.other && e.error is SocketException),
            ),
          );
        },
      );

      test(
        'access -> auth fail -> (refresh -> success) -> retry -> success',
        () async {
          await storage.setAccessToken('a1');
          await storage.setRefreshToken('r1');

          when(() => adapter.fetch(
                any(
                  that: predicate((RequestOptions request) =>
                      request.path == testUrl &&
                      request.method == 'GET' &&
                      request.headers['authorization'] == 'bearer a1' &&
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
                      request.headers['authorization'] == 'bearer a2' &&
                      request.extra[keyRetry] != null),
                ),
                any(),
                any(),
              )).thenAnswer((_) async => ResponseBody(
                Stream.empty(),
                200,
              ));

          await dio.get<dynamic>(testUrl);

          expect(await storage.getAccessToken(), equals('a2'));
          expect(await storage.getRefreshToken(), equals('r2'));
        },
      );

      test(
        'access -> auth fail -> (refresh -> success) -> retry -> network fail',
        () async {
          await storage.setAccessToken('a1');
          await storage.setRefreshToken('r1');

          when(() => adapter.fetch(
                any(
                  that: predicate((RequestOptions request) =>
                      request.path == testUrl &&
                      request.method == 'GET' &&
                      request.headers['authorization'] == 'bearer a1' &&
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
                      request.headers['authorization'] == 'bearer a2' &&
                      request.extra[keyRetry] != null),
                ),
                any(),
                any(),
              )).thenAnswer((_) async => throw SocketException('error'));

          expect(
            () async {
              try {
                await dio.get<dynamic>(testUrl);
              } finally {
                expect(await storage.getAccessToken(), equals('a2'));
                expect(await storage.getRefreshToken(), equals('r2'));
              }
            },
            throwsA(
              predicate((DioError e) =>
                  e.type == DioErrorType.other && e.error is SocketException),
            ),
          );
        },
      );

      test(
        'access -> auth fail -> (refresh -> success) -> retry -> auth fail',
        () async {
          await storage.setAccessToken('a1');
          await storage.setRefreshToken('r1');

          when(() => adapter.fetch(
                any(
                  that: predicate((RequestOptions request) =>
                      request.path == testUrl &&
                      request.method == 'GET' &&
                      request.headers['authorization'] == 'bearer a1' &&
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
                      request.headers['authorization'] == 'bearer a2' &&
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
                expect(await storage.getAccessToken(), isNull);
                expect(await storage.getRefreshToken(), isNull);
              }
            },
            throwsA(
              predicate((DioError e) =>
                  e.type == DioErrorType.other && e.error is AuthException),
            ),
          );
        },
      );

      test(
        'access -> auth fail -> (refresh -> network fail)',
        () async {
          await storage.setAccessToken('a1');
          await storage.setRefreshToken('r1');

          when(() => adapter.fetch(
                any(
                  that: predicate((RequestOptions request) =>
                      request.path == testUrl &&
                      request.method == 'GET' &&
                      request.headers['authorization'] == 'bearer a1' &&
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
              )).thenAnswer((_) async => throw SocketException('error'));

          expect(
            () async {
              try {
                await dio.get<dynamic>(testUrl);
              } finally {
                expect(await storage.getAccessToken(), isNull);
                expect(await storage.getRefreshToken(), equals('r1'));
              }
            },
            throwsA(
              predicate((DioError e) =>
                  e.type == DioErrorType.other && e.error is SocketException),
            ),
          );
        },
      );

      test(
        'access -> auth fail -> (refresh -> auth fail)',
        () async {
          await storage.setAccessToken('a1');
          await storage.setRefreshToken('r1');

          when(() => adapter.fetch(
                any(
                  that: predicate((RequestOptions request) =>
                      request.path == testUrl &&
                      request.method == 'GET' &&
                      request.headers['authorization'] == 'bearer a1' &&
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
                expect(await storage.getAccessToken(), isNull);
                expect(await storage.getRefreshToken(), isNull);
              }
            },
            throwsA(
              predicate((DioError e) =>
                  e.type == DioErrorType.other && e.error is AuthException),
            ),
          );
        },
      );

      test(
        'access -> auth fail -> !refresh',
        () async {
          await storage.setAccessToken('a1');

          when(() => adapter.fetch(
                any(
                  that: predicate((RequestOptions request) =>
                      request.path == testUrl &&
                      request.method == 'GET' &&
                      request.headers['authorization'] == 'bearer a1' &&
                      request.extra[keyRetry] == null),
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
                expect(await storage.getAccessToken(), isNull);
                expect(await storage.getRefreshToken(), isNull);
              }
            },
            throwsA(
              predicate((DioError e) =>
                  e.type == DioErrorType.other && e.error is AuthException),
            ),
          );
        },
      );

      test(
        '!access -> (refresh -> success) -> retry -> success',
        () async {
          await storage.setRefreshToken('r1');

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
                      request.headers['authorization'] == 'bearer a2' &&
                      request.extra[keyRetry] == null),
                ),
                any(),
                any(),
              )).thenAnswer((_) async => ResponseBody(
                Stream.empty(),
                200,
              ));

          await dio.get<dynamic>(testUrl);

          expect(await storage.getAccessToken(), equals('a2'));
          expect(await storage.getRefreshToken(), equals('r2'));
        },
      );

      test(
        '!access -> (refresh -> success) -> retry -> network fail',
        () async {
          await storage.setRefreshToken('r1');

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
                      request.headers['authorization'] == 'bearer a2' &&
                      request.extra[keyRetry] == null),
                ),
                any(),
                any(),
              )).thenAnswer((_) async => throw SocketException('error'));

          expect(
            () async {
              try {
                await dio.get<dynamic>(testUrl);
              } finally {
                expect(await storage.getAccessToken(), equals('a2'));
                expect(await storage.getRefreshToken(), equals('r2'));
              }
            },
            throwsA(
              predicate((DioError e) =>
                  e.type == DioErrorType.other && e.error is SocketException),
            ),
          );
        },
      );

      test(
        'access -> (refresh -> network fail)',
        () async {
          await storage.setRefreshToken('r1');

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
              )).thenAnswer((_) async => throw SocketException('error'));

          expect(
            () async {
              try {
                await dio.get<dynamic>(testUrl);
              } finally {
                expect(await storage.getAccessToken(), isNull);
                expect(await storage.getRefreshToken(), equals('r1'));
              }
            },
            throwsA(
              predicate((DioError e) =>
                  e.type == DioErrorType.other && e.error is SocketException),
            ),
          );
        },
      );

      test(
        'access -> (refresh -> auth fail)',
        () async {
          await storage.setRefreshToken('r1');

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
                expect(await storage.getAccessToken(), isNull);
                expect(await storage.getRefreshToken(), isNull);
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
}
