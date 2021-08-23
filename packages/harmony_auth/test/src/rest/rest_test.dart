import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/checker/checker.dart';
import 'package:harmony_auth/src/matcher/matcher.dart';
import 'package:harmony_auth/src/rest/impl/impl.dart';
import 'package:harmony_auth/src/rest/rest.dart';
import 'package:harmony_auth/src/token/token.dart';
import 'package:mocktail/mocktail.dart';

const keyRetry = 'harmony_auth_is_retry';
const testUrl = 'https://test';
const refreshUrl = 'https://refresh';

class MockAdapter extends Mock implements HttpClientAdapter {}

class FakeRequestOptions extends Fake implements RequestOptions {}

class OtherError {}

void main() {
  group('AuthRest', () {
    group('standard', () {
      group('method refreshTokens', () {
        late MockAdapter adapter;
        late AuthRest rest;

        setUp(() {
          registerFallbackValue(FakeRequestOptions());
          adapter = MockAdapter();
          when(() => adapter.close()).thenAnswer((_) {});
          rest = AuthRest(
            dio: Dio()..httpClientAdapter = adapter,
            refreshUrl: refreshUrl,
            checker: AuthChecker(),
          );
        });

        tearDown(() {
          resetMocktailState();
        });

        test(
          'when response is ok then should return tokens',
          () async {
            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == refreshUrl &&
                        request.method == 'POST' &&
                        request.headers['content-type'] == 'application/json' &&
                        request.headers['accept'] == 'application/json' &&
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

            final pair = await rest.refreshTokens('r1');
            expect(pair.refresh, equals('r2'));
            expect(pair.access, equals('a2'));
          },
        );

        test(
          'when is unauthorized then should error with AuthException',
          () async {
            when(() => adapter.fetch(
                  any(
                    that: predicate(
                      (RequestOptions request) =>
                          request.path == refreshUrl &&
                          request.method == 'POST' &&
                          request.headers['content-type'] ==
                              'application/json' &&
                          request.headers['accept'] == 'application/json' &&
                          request.data['refresh'] == 'r1',
                    ),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  401,
                  headers: {
                    'content-type': ['application/json'],
                    'accept': ['application/json'],
                  },
                ));

            expect(
              () async => await rest.refreshTokens('r1'),
              throwsA(isA<AuthRestExceptionStandardImpl>()),
            );
          },
        );

        test(
          'when has bad response then should error with Exception',
          () async {
            when(() => adapter.fetch(
                  any(
                    that: predicate(
                      (RequestOptions request) =>
                          request.path == refreshUrl &&
                          request.method == 'POST' &&
                          request.headers['content-type'] ==
                              'application/json' &&
                          request.headers['accept'] == 'application/json' &&
                          request.data['refresh'] == 'r1',
                    ),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.fromIterable([
                    Uint8List.fromList(
                      utf8.encode(
                        '{"hello": "hi"}',
                      ),
                    ),
                  ]),
                  200,
                  headers: {
                    'content-type': ['application/json'],
                    'accept': ['application/json'],
                  },
                ));

            expect(
              () async => await rest.refreshTokens('r1'),
              throwsA(
                predicate(
                  (DioError e) =>
                      e.type == DioErrorType.other &&
                      e.error is Exception &&
                      e.requestOptions.path == refreshUrl,
                ),
              ),
            );
          },
        );

        test(
          'when with network error then should error with OtherError',
          () async {
            when(() => adapter.fetch(
                  any(
                    that: predicate(
                      (RequestOptions request) =>
                          request.path == refreshUrl &&
                          request.method == 'POST' &&
                          request.headers['content-type'] ==
                              'application/json' &&
                          request.headers['accept'] == 'application/json' &&
                          request.data['refresh'] == 'r1',
                    ),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => throw OtherError());

            expect(
              () async => await rest.refreshTokens('r1'),
              throwsA(
                predicate((DioError e) =>
                    e.type == DioErrorType.other && e.error is OtherError),
              ),
            );
          },
        );
      });

      test('getter refreshTokensMatcher', () {
        final rest = AuthRest(
          dio: Dio(),
          refreshUrl: refreshUrl,
          checker: AuthChecker(),
        );

        final matcher = rest.refreshTokensMatcher;
        expect(
          matcher.matchesRequest(RequestOptions(
            path: refreshUrl,
            method: 'POST',
          )),
          isTrue,
        );
        expect(
          matcher.matchesRequest(RequestOptions(
            path: refreshUrl,
            method: 'GET',
          )),
          isFalse,
        );
        expect(
          matcher.matchesRequest(RequestOptions(
            path: testUrl,
            method: 'POST',
          )),
          isFalse,
        );
      });
    });

    group('accessOnly', () {
      group('method refreshTokens', () {
        late MockAdapter adapter;
        late AuthRest rest;

        setUp(() {
          registerFallbackValue(FakeRequestOptions());
          adapter = MockAdapter();
          when(() => adapter.close()).thenAnswer((_) {});
          rest = AuthRest.accessOnly(
            dio: Dio()..httpClientAdapter = adapter,
            refreshUrl: refreshUrl,
            checker: AuthChecker(),
          );
        });

        tearDown(() {
          resetMocktailState();
        });

        test(
          'when response is ok then should return tokens',
          () async {
            when(() => adapter.fetch(
                  any(
                    that: predicate((RequestOptions request) =>
                        request.path == refreshUrl &&
                        request.method == 'POST' &&
                        request.headers['content-type'] == 'application/json' &&
                        request.headers['accept'] == 'application/json' &&
                        request.data['refresh'] == 'r1'),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.fromIterable([
                    Uint8List.fromList(
                      utf8.encode(
                        '{"access":"a2"}',
                      ),
                    ),
                  ]),
                  200,
                  headers: {
                    'content-type': ['application/json'],
                    'accept': ['application/json'],
                  },
                ));

            final pair = await rest.refreshTokens('r1');
            expect(pair.refresh, equals('r1'));
            expect(pair.access, equals('a2'));
          },
        );

        test(
          'when is unauthorized then should error with AuthException',
          () async {
            when(() => adapter.fetch(
                  any(
                    that: predicate(
                      (RequestOptions request) =>
                          request.path == refreshUrl &&
                          request.method == 'POST' &&
                          request.headers['content-type'] ==
                              'application/json' &&
                          request.headers['accept'] == 'application/json' &&
                          request.data['refresh'] == 'r1',
                    ),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.empty(),
                  401,
                  headers: {
                    'content-type': ['application/json'],
                    'accept': ['application/json'],
                  },
                ));

            expect(
              () async => await rest.refreshTokens('r1'),
              throwsA(isA<AuthRestExceptionAccessOnlyImpl>()),
            );
          },
        );

        test(
          'when has bad response then should error with AssertionError',
          () async {
            when(() => adapter.fetch(
                  any(
                    that: predicate(
                      (RequestOptions request) =>
                          request.path == refreshUrl &&
                          request.method == 'POST' &&
                          request.headers['content-type'] ==
                              'application/json' &&
                          request.headers['accept'] == 'application/json' &&
                          request.data['refresh'] == 'r1',
                    ),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => ResponseBody(
                  Stream.fromIterable([
                    Uint8List.fromList(
                      utf8.encode(
                        '{"hello": "hi"}',
                      ),
                    ),
                  ]),
                  200,
                  headers: {
                    'content-type': ['application/json'],
                    'accept': ['application/json'],
                  },
                ));

            expect(
              () async => await rest.refreshTokens('r1'),
              throwsA(
                predicate(
                  (DioError e) =>
                      e.type == DioErrorType.other &&
                      e.error is Exception &&
                      e.requestOptions.path == refreshUrl,
                ),
              ),
            );
          },
        );

        test(
          'when with network error then should error with OtherError',
          () async {
            when(() => adapter.fetch(
                  any(
                    that: predicate(
                      (RequestOptions request) =>
                          request.path == refreshUrl &&
                          request.method == 'POST' &&
                          request.headers['content-type'] ==
                              'application/json' &&
                          request.headers['accept'] == 'application/json' &&
                          request.data['refresh'] == 'r1',
                    ),
                  ),
                  any(),
                  any(),
                )).thenAnswer((_) async => throw OtherError());

            expect(
              () async => await rest.refreshTokens('r1'),
              throwsA(
                predicate((DioError e) =>
                    e.type == DioErrorType.other && e.error is OtherError),
              ),
            );
          },
        );
      });

      test('getter refreshTokensMatcher', () {
        final rest = AuthRest.accessOnly(
          dio: Dio(),
          refreshUrl: refreshUrl,
          checker: AuthChecker(),
        );

        final matcher = rest.refreshTokensMatcher;

        expect(
          matcher.matchesRequest(RequestOptions(
            path: refreshUrl,
            method: 'POST',
          )),
          isTrue,
        );
        expect(
          matcher.matchesRequest(RequestOptions(
            path: refreshUrl,
            method: 'GET',
          )),
          isFalse,
        );
        expect(
          matcher.matchesRequest(RequestOptions(
            path: testUrl,
            method: 'POST',
          )),
          isFalse,
        );
      });
    });

    group('general', () {
      test('test', () async {
        final dio = Dio();
        final matcher = AuthMatcher.all();
        final rest = AuthRest.general(
          dio: dio,
          refreshTokensMatcher: matcher,
          refresh: (d, r) async {
            expect(d, equals(dio));
            expect(r, equals('r1'));
            return AuthToken(
              access: 'a2',
              refresh: 'r2',
            );
          },
        );
        expect(rest.refreshTokensMatcher, equals(matcher));
        final token = await rest.refreshTokens('r1');
        expect(token.refresh, equals('r2'));
        expect(token.access, equals('a2'));
      });
    });
  });

  group('AuthRestException', () {
    group('external', () {
      test('instantiation', () {
        final e = AuthRestException();
        expect(e, isA<AuthRestException>());
        expect(e.toString(), stringContainsInOrder(['AuthRestException']));
      });
    });

    group('standard', () {
      test('instantiation', () {
        final e = AuthRestExceptionStandardImpl();
        expect(e, isA<AuthRestException>());
        expect(
          e.toString(),
          stringContainsInOrder(['AuthRestException', 'standard']),
        );
      });
    });

    group('accessOnly', () {
      test('instantiation', () {
        final e = AuthRestExceptionAccessOnlyImpl();
        expect(e, isA<AuthRestException>());
        expect(
          e.toString(),
          stringContainsInOrder(['AuthRestException', 'accessOnly']),
        );
      });
    });
  });
}
