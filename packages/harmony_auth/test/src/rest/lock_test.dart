import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_auth/src/matcher/matcher.dart';
import 'package:harmony_auth/src/rest/rest.dart';
import 'package:harmony_auth/src/utils/error_extensions.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRest extends Mock implements AuthRest {}

class FakeAuthRestToken extends Fake implements AuthRestToken {}

class FakeAuthMatcher extends Fake implements AuthMatcher {}

class FakeRequestOptions extends Fake implements RequestOptions {}

Future<void> delay(int millis) =>
    Future<void>.delayed(Duration(milliseconds: millis));

void main() {
  group('AuthRest+Lock', () {
    tearDown(() {
      resetMocktailState();
    });

    group('refreshTokensMatcher', () {
      test('extension method', () {
        final matcher = FakeAuthMatcher();
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        when(() => base.refreshTokensMatcher).thenReturn(matcher);
        expect(rest.refreshTokensMatcher, equals(matcher));
      });

      test('factory', () {
        final matcher = FakeAuthMatcher();
        final base = MockAuthRest();
        final rest = AuthRest.withLock(base);
        when(() => base.refreshTokensMatcher).thenReturn(matcher);
        expect(rest.refreshTokensMatcher, equals(matcher));
      });
    });

    group('refreshTokens', () {
      test('1 success', () async {
        var count = 0;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        final pair2 = FakeAuthRestToken();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count++;
          await delay(10);
          return pair2;
        });

        final result = await rest.refreshTokens('r1');
        expect(result, equals(pair2));

        expect(count, equals(1));
      });

      test('1 fail auth', () async {
        var count = 0;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count++;
          await delay(10);
          throw AuthException().toDioError(FakeRequestOptions());
        });

        try {
          await rest.refreshTokens('r1');
          fail('error');
        } on DioError catch (e) {
          expect(e.isAuthException, isTrue);
        }

        expect(count, equals(1));
      });

      test('1 fail other', () async {
        var count = 0;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count++;
          await delay(10);
          throw DioError(requestOptions: FakeRequestOptions());
        });

        try {
          await rest.refreshTokens('r1');
          fail('error');
        } on DioError catch (e) {
          expect(e.isAuthException, isFalse);
        }

        expect(count, equals(1));
      });

      test('5 success', () async {
        var count = 0;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        final pair2 = FakeAuthRestToken();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count++;
          await delay(50);
          return pair2;
        });

        await Future.wait(
          List.generate(
            5,
            (_) async {
              final result = await rest.refreshTokens('r1');
              expect(result, equals(pair2));
            },
          ),
          eagerError: false,
        );

        expect(count, equals(1));
      });

      test('5 success + 5 success', () async {
        var count = 0;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        final pair2 = FakeAuthRestToken();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count++;
          await delay(50);
          return pair2;
        });

        await Future.wait(
          List.generate(
            5,
            (_) async {
              final result = await rest.refreshTokens('r1');
              expect(result, equals(pair2));
            },
          ),
          eagerError: false,
        );

        await delay(100);

        await Future.wait(
          List.generate(
            5,
            (_) async {
              final result = await rest.refreshTokens('r1');
              expect(result, equals(pair2));
            },
          ),
          eagerError: false,
        );

        expect(count, equals(1));
      });

      test('5 fail auth', () async {
        var count = 0;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count++;
          await delay(50);
          throw AuthException().toDioError(FakeRequestOptions());
        });

        await Future.wait(
          List.generate(
            5,
            (index) async {
              try {
                await rest.refreshTokens('r1');
                fail('error $index');
              } on DioError catch (e) {
                expect(e.isAuthException, isTrue);
              }
            },
          ),
          eagerError: false,
        );

        expect(count, equals(1));
      });

      test('5 fail auth + 5 fail auth', () async {
        var count = 0;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count++;
          await delay(50);
          throw AuthException().toDioError(FakeRequestOptions());
        });

        await Future.wait(
          List.generate(
            5,
            (index) async {
              try {
                await rest.refreshTokens('r1');
                fail('error $index');
              } on DioError catch (e) {
                expect(e.isAuthException, isTrue);
              }
            },
          ),
          eagerError: false,
        );

        await delay(100);

        await Future.wait(
          List.generate(
            5,
            (index) async {
              try {
                await rest.refreshTokens('r1');
                fail('error $index');
              } on DioError catch (e) {
                expect(e.isAuthException, isTrue);
              }
            },
          ),
          eagerError: false,
        );

        expect(count, equals(1));
      });

      test('5 fail other', () async {
        var count = 0;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count++;
          await delay(50);
          throw DioError(requestOptions: FakeRequestOptions());
        });

        await Future.wait(
          List.generate(
            5,
            (index) async {
              try {
                await rest.refreshTokens('r1');
                fail('error $index');
              } on DioError catch (e) {
                expect(e.isAuthException, isFalse);
              }
            },
          ),
          eagerError: false,
        );

        expect(count, greaterThanOrEqualTo(1));
      });

      test('5 fail other + 5 fail other', () async {
        var count = 0;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count++;
          await delay(50);
          throw DioError(requestOptions: FakeRequestOptions());
        });

        await Future.wait(
          List.generate(
            5,
            (index) async {
              try {
                await rest.refreshTokens('r1');
                fail('error $index');
              } on DioError catch (e) {
                expect(e.isAuthException, isFalse);
              }
            },
          ),
          eagerError: false,
        );

        await delay(100);

        await Future.wait(
          List.generate(
            5,
            (index) async {
              try {
                await rest.refreshTokens('r1');
                fail('error $index');
              } on DioError catch (e) {
                expect(e.isAuthException, isFalse);
              }
            },
          ),
          eagerError: false,
        );

        expect(count, greaterThanOrEqualTo(2));
      });

      test('5 fail other + 5 success', () async {
        var count = 0;
        var flag = false;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        final pair2 = FakeAuthRestToken();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count++;
          await delay(50);
          if (flag) {
            return pair2;
          } else {
            throw DioError(requestOptions: FakeRequestOptions());
          }
        });

        await Future.wait(
          List.generate(
            5,
            (index) async {
              try {
                await rest.refreshTokens('r1');
                fail('error $index');
              } on DioError catch (e) {
                expect(e.isAuthException, isFalse);
              }
            },
          ),
          eagerError: false,
        );

        await delay(100);
        flag = true;

        await Future.wait(
          List.generate(
            5,
            (_) async {
              final result = await rest.refreshTokens('r1');
              expect(result, equals(pair2));
            },
          ),
          eagerError: false,
        );

        expect(count, greaterThanOrEqualTo(2));
      });

      test('5 success + 5 success', () async {
        var count1 = 0;
        var count2 = 0;
        final base = MockAuthRest();
        final rest = base.wrapWithLock();
        final pair2 = FakeAuthRestToken();
        final pair3 = FakeAuthRestToken();
        when(() => base.refreshTokens('r1')).thenAnswer((_) async {
          count1++;
          await delay(50);
          return pair2;
        });
        when(() => base.refreshTokens('r2')).thenAnswer((_) async {
          count2++;
          await delay(50);
          return pair3;
        });

        await Future.wait(
          List.generate(
            5,
            (_) async {
              final result = await rest.refreshTokens('r1');
              expect(result, equals(pair2));
            },
          ),
          eagerError: false,
        );

        await delay(100);

        await Future.wait(
          List.generate(
            5,
            (_) async {
              final result = await rest.refreshTokens('r2');
              expect(result, equals(pair3));
            },
          ),
          eagerError: false,
        );

        expect(count1, equals(1));
        expect(count2, equals(1));
      });
    });
  });
}
