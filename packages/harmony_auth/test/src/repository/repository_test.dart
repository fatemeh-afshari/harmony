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
            when(() => rest.refreshTokens(token1))
                .thenAnswer((_) async => token2);
            await repository.refreshTokens();
            expect(await storage.getToken(), equals(token2));
          });

          test('fail auth', () {
            when(() => rest.refreshTokens(token1))
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
            when(() => rest.refreshTokens(token1))
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

    group('standard+locked', () {
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
            when(() => rest.refreshTokens(token1))
                .thenAnswer((_) async => token2);
            await repository.refreshTokens();
            expect(await storage.getToken(), equals(token2));
          });

          test('fail auth', () {
            when(() => rest.refreshTokens(token1))
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
            when(() => rest.refreshTokens(token1))
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

    group('standard+debounce', () {
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
            when(() => rest.refreshTokens(token1))
                .thenAnswer((_) async => token2);
            await repository.refreshTokens();
            expect(await storage.getToken(), equals(token2));
          });

          test('fail auth', () {
            when(() => rest.refreshTokens(token1))
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
            when(() => rest.refreshTokens(token1))
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

    group('standard+debounce+locked', () {
      setUp(() {
        repository = repository.debounce(Duration(minutes: 1)).locked();
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
            when(() => rest.refreshTokens(token1))
                .thenAnswer((_) async => token2);
            await repository.refreshTokens();
            expect(await storage.getToken(), equals(token2));
          });

          test('fail auth', () {
            when(() => rest.refreshTokens(token1))
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
            when(() => rest.refreshTokens(token1))
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

  group('AuthRepository (streaming)', () {
    late AuthRepository repository;
    late AuthStorage storage;

    group('streaming -> standard', () {
      setUp(() {
        storage = AuthStorage.inMemory().streaming();
        repository = AuthRepository(
          storage: storage,
          rest: FakeAuthRest(),
        );
      });

      test('status', () async {
        expect(
          await repository.status,
          equals(AuthStatus.loggedOut),
        );
        await storage.setToken(token1);
        expect(
          await repository.status,
          equals(AuthStatus.loggedIn),
        );
      });

      test('initializeStatusStream', () async {
        expect(
          repository.statusStream,
          emits(AuthStatus.loggedOut),
        );
        await repository.initializeStatusStream();
      });

      test('status stream', () async {
        expect(
          repository.statusStream,
          emitsInOrder(<AuthStatus>[
            AuthStatus.loggedOut,
            AuthStatus.loggedIn,
            AuthStatus.loggedOut,
            AuthStatus.loggedIn,
            AuthStatus.loggedOut,
          ]),
        );
        await repository.initializeStatusStream();
        await repository.setToken(token1);
        await repository.removeToken();
        await repository.setToken(token1);
        await repository.removeToken();
      });
    });

    group('streaming -> standard+locked', () {
      setUp(() {
        storage = AuthStorage.inMemory().streaming();
        repository = AuthRepository(
          storage: storage,
          rest: FakeAuthRest(),
        ).locked();
      });

      test('status', () async {
        expect(
          await repository.status,
          equals(AuthStatus.loggedOut),
        );
        await storage.setToken(token1);
        expect(
          await repository.status,
          equals(AuthStatus.loggedIn),
        );
      });

      test('initializeStatusStream', () async {
        expect(
          repository.statusStream,
          emits(AuthStatus.loggedOut),
        );
        await repository.initializeStatusStream();
      });

      test('status stream', () async {
        expect(
          repository.statusStream,
          emitsInOrder(<AuthStatus>[
            AuthStatus.loggedOut,
            AuthStatus.loggedIn,
            AuthStatus.loggedOut,
            AuthStatus.loggedIn,
            AuthStatus.loggedOut,
          ]),
        );
        await repository.initializeStatusStream();
        await repository.setToken(token1);
        await repository.removeToken();
        await repository.setToken(token1);
        await repository.removeToken();
      });
    });

    group('streaming -> standard+debounce', () {
      setUp(() {
        storage = AuthStorage.inMemory().streaming();
        repository = AuthRepository(
          storage: storage,
          rest: FakeAuthRest(),
        ).debounce(Duration(minutes: 1));
      });

      test('status', () async {
        expect(
          await repository.status,
          equals(AuthStatus.loggedOut),
        );
        await storage.setToken(token1);
        expect(
          await repository.status,
          equals(AuthStatus.loggedIn),
        );
      });

      test('initializeStatusStream', () async {
        expect(
          repository.statusStream,
          emits(AuthStatus.loggedOut),
        );
        await repository.initializeStatusStream();
      });

      test('status stream', () async {
        expect(
          repository.statusStream,
          emitsInOrder(<AuthStatus>[
            AuthStatus.loggedOut,
            AuthStatus.loggedIn,
            AuthStatus.loggedOut,
            AuthStatus.loggedIn,
            AuthStatus.loggedOut,
          ]),
        );
        await repository.initializeStatusStream();
        await repository.setToken(token1);
        await repository.removeToken();
        await repository.setToken(token1);
        await repository.removeToken();
      });
    });

    group('non-streaming -> standard', () {
      setUp(() {
        storage = AuthStorage.inMemory();
        repository = AuthRepository(
          storage: storage,
          rest: FakeAuthRest(),
        );
      });

      test('status', () {
        expect(
          () async => await repository.status,
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('initializeStatusStream', () {
        expect(
          () async => await repository.initializeStatusStream(),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('status stream', () {
        expect(
          () => repository.statusStream,
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('non-streaming -> standard+locked', () {
      setUp(() {
        storage = AuthStorage.inMemory();
        repository = AuthRepository(
          storage: storage,
          rest: FakeAuthRest(),
        ).locked();
      });

      test('status', () {
        expect(
          () async => await repository.status,
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('initializeStatusStream', () {
        expect(
          () async => await repository.initializeStatusStream(),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('status stream', () {
        expect(
          () => repository.statusStream,
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('non-streaming -> standard+debounce', () {
      setUp(() {
        storage = AuthStorage.inMemory();
        repository = AuthRepository(
          storage: storage,
          rest: FakeAuthRest(),
        ).debounce(Duration(minutes: 1));
      });

      test('status', () {
        expect(
          () async => await repository.status,
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('initializeStatusStream', () {
        expect(
          () async => await repository.initializeStatusStream(),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('status stream', () {
        expect(
          () => repository.statusStream,
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });

  group('AuthRepository (concurrency)', () {
    // todo: not tested yet ...
  });

  group('AuthRepository (debounce)', () {
    // todo: not tested yet ...
  });
}
