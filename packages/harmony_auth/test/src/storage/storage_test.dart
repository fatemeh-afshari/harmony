import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/storage/impl/impl.dart';
import 'package:harmony_auth/src/storage/storage.dart';
import 'package:harmony_auth/src/token/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final example = AuthToken(refresh: 'r1', access: 'a1');

  group('AuthStorage', () {
    late AuthStorage storage;

    group('standard', () {
      setUp(() {
        SharedPreferences.setMockInitialValues({});
        storage = AuthStorage();
      });

      group('initially empty', () {
        group('AuthStorageExt', () {
          group('isLoggedIn', () {
            test('loggedOut', () async {
              expect(await storage.status, equals(AuthStatus.loggedOut));
            });

            test('loggedIn', () async {
              await storage.setToken(example);
              expect(await storage.status, equals(AuthStatus.loggedIn));
            });
          });
        });

        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setToken(example);
          expect(await storage.getToken(), equals(example));
          await storage.removeToken();
          expect(await storage.getToken(), isNull);
        });
      });
    });

    group('standard+inconsistency', () {
      group('with only refresh token', () {
        setUp(() {
          SharedPreferences.setMockInitialValues({
            'harmony_auth_storage_access_token': 'r1',
          });
          storage = AuthStorage();
        });

        test('when having inconsistency then remove and return null', () async {
          expect(await storage.getToken(), isNull);
          final prefs = await SharedPreferences.getInstance();
          expect(prefs.getString('harmony_auth_storage_access_token'), isNull);
        });
      });
    });

    group('inMemory', () {
      setUp(() {
        storage = AuthStorage.inMemory();
      });

      group('initially empty', () {
        group('AuthStorageExt', () {
          group('isLoggedIn', () {
            test('loggedOut', () async {
              expect(await storage.status, equals(AuthStatus.loggedOut));
            });

            test('loggedIn', () async {
              await storage.setToken(example);
              expect(await storage.status, equals(AuthStatus.loggedIn));
            });
          });
        });

        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setToken(example);
          expect(await storage.getToken(), equals(example));
          await storage.removeToken();
          expect(await storage.getToken(), isNull);
        });
      });
    });

    group('standard+locked', () {
      setUp(() {
        SharedPreferences.setMockInitialValues({});
        storage = AuthStorage().locked();
      });

      group('initially empty', () {
        group('AuthStorageExt', () {
          group('isLoggedIn', () {
            test('loggedOut', () async {
              expect(await storage.status, equals(AuthStatus.loggedOut));
            });

            test('loggedIn', () async {
              await storage.setToken(example);
              expect(await storage.status, equals(AuthStatus.loggedIn));
            });
          });
        });

        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setToken(example);
          expect(await storage.getToken(), equals(example));
          await storage.removeToken();
          expect(await storage.getToken(), isNull);
        });
      });
    });

    group('inMemory+locked', () {
      setUp(() {
        storage = AuthStorage.inMemory().locked();
      });

      group('AuthStorageLockedExt', () {
        test('locked', () {
          final s = AuthStorage();
          final s1 = AuthStorage().locked();
          final s2 = AuthStorage.locked(s);
          expect(s1.runtimeType, equals(s2.runtimeType));
        });
      });

      group('initially empty', () {
        group('AuthStorageExt', () {
          group('isLoggedIn', () {
            test('loggedOut', () async {
              expect(await storage.status, equals(AuthStatus.loggedOut));
            });

            test('loggedIn', () async {
              await storage.setToken(example);
              expect(await storage.status, equals(AuthStatus.loggedIn));
            });
          });
        });

        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setToken(example);
          expect(await storage.getToken(), equals(example));
          await storage.removeToken();
          expect(await storage.getToken(), isNull);
        });
      });
    });

    group('standard+exception', () {
      group('given bad type then get', () {
        setUp(() {
          SharedPreferences.setMockInitialValues({
            'harmony_auth_storage_access_token': 12,
            'harmony_auth_storage_refresh_token': 10,
          });
          storage = AuthStorage();
        });

        test('should remove and return null', () async {
          expect(await storage.getToken(), isNull);
          final prefs = await SharedPreferences.getInstance();
          expect(prefs.getString('harmony_auth_storage_access_token'), isNull);
          expect(prefs.getString('harmony_auth_storage_refresh_token'), isNull);
        });

        // todo storage exception not tested ...
      });
    });

    group('inMemory+streaming', () {
      final example = AuthToken(refresh: 'r1', access: 'a1');

      group('without status', () {
        late AuthStorage storage;

        setUp(() {
          storage = AuthStorage.inMemory();
        });

        test('status', () async {
          expect(await storage.status, equals(AuthStatus.loggedOut));
        });

        test('statusStreamOrNull', () {
          expect(storage.statusStreamOrNull, isNull);
        });

        test('statusStream', () {
          expect(() => storage.statusStream, throwsA(anything));
        });

        test('initializeStatusStreamOrNothing', () async {
          await storage.initializeStatusStreamOrNothing();
        });

        test('initializeStatusStream', () {
          expect(
            () async => await storage.initializeStatusStream(),
            throwsA(anything),
          );
        });
      });

      group('with status', () {
        late AuthStorage storage;

        group('without initial token', () {
          setUp(() {
            storage = AuthStorage.inMemory().streaming();
          });

          test('status', () async {
            expect(await storage.status, equals(AuthStatus.loggedOut));
          });

          test('statusStreamOrNull', () {
            expect(storage.statusStreamOrNull, isNotNull);
          });

          test('statusStream', () {
            expect(storage.statusStream, isNotNull);
          });

          test('initializeStatusStreamOrNothing', () async {
            expect(storage.statusStream, emits(AuthStatus.loggedOut));
            await storage.initializeStatusStreamOrNothing();
          });

          test('initializeStatusStream', () async {
            expect(storage.statusStream, emits(AuthStatus.loggedOut));
            await storage.initializeStatusStream();
          });

          test('status stream', () async {
            expect(
              storage.statusStream,
              emitsInOrder(<AuthStatus>[
                AuthStatus.loggedOut,
                AuthStatus.loggedIn,
                AuthStatus.loggedOut,
                AuthStatus.loggedIn,
                AuthStatus.loggedOut,
              ]),
            );
            await storage.initializeStatusStream();
            await storage.setToken(example);
            await storage.removeToken();
            await storage.setToken(example);
            await storage.removeToken();
          });
        });

        group('with initial token', () {
          setUp(() {
            storage = AuthStorage.inMemory();
            storage.setToken(example);
            storage = storage.streaming();
          });

          test('status', () async {
            expect(await storage.status, equals(AuthStatus.loggedIn));
          });

          test('statusStreamOrNull', () {
            expect(storage.statusStreamOrNull, isNotNull);
          });

          test('statusStream', () {
            expect(storage.statusStream, isNotNull);
          });

          test('initializeStatusStreamOrNothing', () async {
            expect(storage.statusStream, emits(AuthStatus.loggedIn));
            await storage.initializeStatusStreamOrNothing();
          });

          test('initializeStatusStream', () async {
            expect(storage.statusStream, emits(AuthStatus.loggedIn));
            await storage.initializeStatusStream();
          });

          test('status stream', () async {
            expect(
              storage.statusStream,
              emitsInOrder(<AuthStatus>[
                AuthStatus.loggedIn,
                AuthStatus.loggedOut,
                AuthStatus.loggedIn,
                AuthStatus.loggedOut,
              ]),
            );
            await storage.initializeStatusStream();
            await storage.removeToken();
            await storage.setToken(example);
            await storage.removeToken();
          });
        });
      });
    });
  });

  group('AuthStorageLockedExt', () {
    test('locked', () {
      final s = AuthStorage();
      final s1 = s.locked();
      final s2 = AuthStorage.locked(s);
      expect(s1.runtimeType, equals(s2.runtimeType));
      final s1c = s1 as AuthStorageLockedImpl;
      final s2c = s2 as AuthStorageLockedImpl;
      expect(s1c.base, equals(s2c.base));
    });
  });

  group('AuthStorageStreamingExt', () {
    test('streaming', () {
      final s = AuthStorage();
      final s1 = s.streaming();
      final s2 = AuthStorage.streaming(s);
      expect(s1.runtimeType, equals(s2.runtimeType));
      final s1c = s1 as AuthStorageStreamingImpl;
      final s2c = s2 as AuthStorageStreamingImpl;
      expect(s1c.base, equals(s2c.base));
    });
  });

  group('AuthStorageException', () {
    group('standard', () {
      test('instantiation', () {
        final e = AuthStorageStandardExceptionImpl();
        expect(e, isA<AuthStorageException>());
        expect(
          e.toString(),
          stringContainsInOrder(['AuthStorageException', 'standard']),
        );
      });
    });
  });
}
