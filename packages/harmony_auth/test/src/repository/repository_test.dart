import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/matcher/matcher.dart';
import 'package:harmony_auth/src/repository/impl/impl.dart';
import 'package:harmony_auth/src/repository/repository.dart';
import 'package:harmony_auth/src/rest/rest.dart';
import 'package:harmony_auth/src/storage/storage.dart';
import 'package:harmony_auth/src/token/token.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRest extends Mock implements AuthRest {}

class FakeAuthRest extends Fake implements AuthRest {}

class FakeAuthStorage extends Fake implements AuthStorage {}

class FakeAuthMatcher extends Fake implements AuthMatcher {}

class FakeRequestOptions extends Fake implements RequestOptions {}

const token1 = AuthToken(refresh: 'r1', access: 'a1');
const token2 = AuthToken(refresh: 'r2', access: 'a2');

class OtherError implements Exception {}

class RestError implements AuthRestException {}

void main() {
  group('AuthRepositoryException', () {
    group('standard', () {
      test('initialization', () {
        final e = AuthRepositoryExceptionStandardImpl();
        expect(e, isA<AuthRepositoryException>());
        expect(
          e.toString(),
          stringContainsInOrder(['AuthRepositoryException', 'standard']),
        );
      });
    });
  });

  group('AuthRepository', () {
    late AuthRepository repository;
    late AuthStorage storage;
    late MockAuthRest rest;

    setUp(() {
      storage = AuthStorage.inMemory();
      rest = MockAuthRest();
      repository = AuthRepository(
        storage: storage,
        rest: rest,
      );
    });

    tearDown(() {
      resetMocktailState();
    });

    group('standard', () {
      test('getToken', () async {
        expect(await repository.getToken(), isNull);
        await storage.setToken(token1);
        expect(await repository.getToken(), equals(token1));
      });

      test('setToken', () async {
        await repository.setToken(token1);
        expect(await storage.getToken(), equals(token1));
      });

      test('getToken', () async {
        await storage.setToken(token1);
        await repository.removeToken();
        expect(await storage.getToken(), isNull);
      });

      test('refreshTokensMatcher', () async {
        final m = FakeAuthMatcher();
        when(() => rest.refreshTokensMatcher).thenReturn(m);
        expect(repository.refreshTokensMatcher, equals(m));
      });

      group('refreshTokens', () {
        test('without token', () {
          expect(
            () async => await repository.refreshTokens(),
            throwsA(isA<AuthRepositoryExceptionStandardImpl>()),
          );
        });

        group('with token', () {
          setUp(() async {
            await storage.setToken(token1);
          });

          test('success', () async {
            when(() => rest.refreshTokens(token1.refresh))
                .thenAnswer((_) async => token2);
            await repository.refreshTokens();
            expect(await storage.getToken(), equals(token2));
          });

          test('fail auth', () {
            when(() => rest.refreshTokens(token1.refresh))
                .thenAnswer((_) async => throw RestError());
            expect(
              () async {
                try {
                  await repository.refreshTokens();
                } finally {
                  expect(await storage.getToken(), isNull);
                }
              },
              throwsA(isA<AuthRepositoryExceptionStandardImpl>()),
            );
          });

          test('fail other', () {
            when(() => rest.refreshTokens(token1.refresh))
                .thenAnswer((_) async => throw DioError(
                      requestOptions: FakeRequestOptions(),
                      error: OtherError(),
                    ));
            expect(
              () async {
                try {
                  await repository.refreshTokens();
                } finally {
                  expect(await storage.getToken(), equals(token1));
                }
              },
              throwsA(allOf(
                isA<DioError>(),
                predicate(
                  (DioError e) => e.error is OtherError,
                ),
              )),
            );
          });
        });
      });
    });

    group('locked', () {
      setUp(() {
        repository = repository.locked();
      });

      test('getToken', () async {
        expect(await repository.getToken(), isNull);
        await storage.setToken(token1);
        expect(await repository.getToken(), equals(token1));
      });

      test('setToken', () async {
        await repository.setToken(token1);
        expect(await storage.getToken(), equals(token1));
      });

      test('getToken', () async {
        await storage.setToken(token1);
        await repository.removeToken();
        expect(await storage.getToken(), isNull);
      });

      test('refreshTokensMatcher', () async {
        final m = FakeAuthMatcher();
        when(() => rest.refreshTokensMatcher).thenReturn(m);
        expect(repository.refreshTokensMatcher, equals(m));
      });

      group('refreshTokens', () {
        test('without token', () {
          expect(
            () async => await repository.refreshTokens(),
            throwsA(isA<AuthRepositoryExceptionStandardImpl>()),
          );
        });

        group('with token', () {
          setUp(() async {
            await storage.setToken(token1);
          });

          test('success', () async {
            when(() => rest.refreshTokens(token1.refresh))
                .thenAnswer((_) async => token2);
            await repository.refreshTokens();
            expect(await storage.getToken(), equals(token2));
          });

          test('fail auth', () {
            when(() => rest.refreshTokens(token1.refresh))
                .thenAnswer((_) async => throw RestError());
            expect(
              () async {
                try {
                  await repository.refreshTokens();
                } finally {
                  expect(await storage.getToken(), isNull);
                }
              },
              throwsA(isA<AuthRepositoryExceptionStandardImpl>()),
            );
          });

          test('fail other', () {
            when(() => rest.refreshTokens(token1.refresh))
                .thenAnswer((_) async => throw DioError(
                      requestOptions: FakeRequestOptions(),
                      error: OtherError(),
                    ));
            expect(
              () async {
                try {
                  await repository.refreshTokens();
                } finally {
                  expect(await storage.getToken(), equals(token1));
                }
              },
              throwsA(allOf(
                isA<DioError>(),
                predicate(
                  (DioError e) => e.error is OtherError,
                ),
              )),
            );
          });
        });
      });
    });

    group('debounce', () {
      setUp(() {
        repository = repository.debounce(Duration(minutes: 1));
      });

      test('getToken', () async {
        expect(await repository.getToken(), isNull);
        await storage.setToken(token1);
        expect(await repository.getToken(), equals(token1));
      });

      test('setToken', () async {
        await repository.setToken(token1);
        expect(await storage.getToken(), equals(token1));
      });

      test('getToken', () async {
        await storage.setToken(token1);
        await repository.removeToken();
        expect(await storage.getToken(), isNull);
      });

      test('refreshTokensMatcher', () async {
        final m = FakeAuthMatcher();
        when(() => rest.refreshTokensMatcher).thenReturn(m);
        expect(repository.refreshTokensMatcher, equals(m));
      });

      group('refreshTokens', () {
        test('without token', () {
          expect(
            () async => await repository.refreshTokens(),
            throwsA(isA<AuthRepositoryExceptionStandardImpl>()),
          );
        });

        group('with token', () {
          setUp(() async {
            await storage.setToken(token1);
          });

          test('success', () async {
            when(() => rest.refreshTokens(token1.refresh))
                .thenAnswer((_) async => token2);
            await repository.refreshTokens();
            expect(await storage.getToken(), equals(token2));
          });

          test('fail auth', () {
            when(() => rest.refreshTokens(token1.refresh))
                .thenAnswer((_) async => throw RestError());
            expect(
              () async {
                try {
                  await repository.refreshTokens();
                } finally {
                  expect(await storage.getToken(), isNull);
                }
              },
              throwsA(isA<AuthRepositoryExceptionStandardImpl>()),
            );
          });

          test('fail other', () {
            when(() => rest.refreshTokens(token1.refresh))
                .thenAnswer((_) async => throw DioError(
                      requestOptions: FakeRequestOptions(),
                      error: OtherError(),
                    ));
            expect(
              () async {
                try {
                  await repository.refreshTokens();
                } finally {
                  expect(await storage.getToken(), equals(token1));
                }
              },
              throwsA(allOf(
                isA<DioError>(),
                predicate(
                  (DioError e) => e.error is OtherError,
                ),
              )),
            );
          });
        });
      });
    });
  });

  group('AuthRepositoryLockedExt', () {
    test('locked', () {
      final s = AuthRepository(
        storage: FakeAuthStorage(),
        rest: FakeAuthRest(),
      );
      final s1 = s.locked();
      final s2 = AuthRepository.locked(s);
      expect(s1.runtimeType, equals(s2.runtimeType));
      final s1c = s1 as AuthRepositoryLockedImpl;
      final s2c = s2 as AuthRepositoryLockedImpl;
      expect(s1c.base, equals(s2c.base));
    });
  });

  group('AuthRepositoryDebounceExt', () {
    test('debounce', () {
      final s = AuthRepository(
        storage: FakeAuthStorage(),
        rest: FakeAuthRest(),
      );
      final d = Duration(minutes: 1);
      final s1 = s.debounce(d);
      final s2 = AuthRepository.debounce(s, duration: d);
      expect(s1.runtimeType, equals(s2.runtimeType));
      final s1c = s1 as AuthRepositoryDebounceImpl;
      final s2c = s2 as AuthRepositoryDebounceImpl;
      expect(s1c.base, equals(s2c.base));
      expect(s1c.duration, equals(s2c.duration));
    });
  });
}
