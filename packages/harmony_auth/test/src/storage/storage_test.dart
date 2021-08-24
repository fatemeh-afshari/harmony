import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/storage/impl/impl.dart';
import 'package:harmony_auth/src/storage/storage.dart';
import 'package:harmony_auth/src/token/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

final token1 = AuthToken(refresh: 'r1', access: 'a1');

void main() {
  group('AuthStorage', () {
    late AuthStorage storage;

    group('standard having inconsistency', () {
      group('given with only refresh token when getToken', () {
        setUp(() {
          SharedPreferences.setMockInitialValues({
            'harmony_auth_storage_access_token': 'r1',
          });
          storage = AuthStorage();
        });

        test('then remove and return null', () async {
          expect(await storage.getToken(), isNull);
          final prefs = await SharedPreferences.getInstance();
          expect(prefs.getString('harmony_auth_storage_access_token'), isNull);
        });
      });

      group('given bad type then getToken', () {
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
      });
    });

    group('standard making exception', () {
      // todo: can not be tested ...
    });

    group('standard', () {
      setUp(() {
        SharedPreferences.setMockInitialValues({});
        storage = AuthStorage();
      });

      group('initially empty', () {
        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setToken(token1);
          expect(await storage.getToken(), equals(token1));
          await storage.removeToken();
          expect(await storage.getToken(), isNull);
        });

        group('status operations', () {
          test('status', () {
            expect(
              () async => await storage.status,
              throwsA(isA<UnimplementedError>()),
            );
          });

          test('statusStream', () {
            expect(
              () => storage.statusStream,
              throwsA(isA<UnimplementedError>()),
            );
          });

          test('initializeStatusStream', () {
            expect(
              () async => await storage.initializeStatusStream(),
              throwsA(isA<UnimplementedError>()),
            );
          });
        });
      });
    });

    group('inMemory', () {
      setUp(() {
        storage = AuthStorage.inMemory();
      });

      group('initially empty', () {
        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setToken(token1);
          expect(await storage.getToken(), equals(token1));
          await storage.removeToken();
          expect(await storage.getToken(), isNull);
        });

        group('status operations', () {
          test('status', () {
            expect(
              () async => await storage.status,
              throwsA(isA<UnimplementedError>()),
            );
          });

          test('statusStream', () {
            expect(
              () => storage.statusStream,
              throwsA(isA<UnimplementedError>()),
            );
          });

          test('initializeStatusStream', () {
            expect(
              () async => await storage.initializeStatusStream(),
              throwsA(isA<UnimplementedError>()),
            );
          });
        });
      });
    });

    group('standard+locked', () {
      setUp(() {
        SharedPreferences.setMockInitialValues({});
        storage = AuthStorage().locked();
      });

      group('initially empty', () {
        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setToken(token1);
          expect(await storage.getToken(), equals(token1));
          await storage.removeToken();
          expect(await storage.getToken(), isNull);
        });

        group('status operations', () {
          test('status', () {
            expect(
              () async => await storage.status,
              throwsA(isA<UnimplementedError>()),
            );
          });

          test('statusStream', () {
            expect(
              () => storage.statusStream,
              throwsA(isA<UnimplementedError>()),
            );
          });

          test('initializeStatusStream', () {
            expect(
              () async => await storage.initializeStatusStream(),
              throwsA(isA<UnimplementedError>()),
            );
          });
        });
      });
    });

    group('inMemory+locked', () {
      setUp(() {
        storage = AuthStorage.inMemory().locked();
      });

      group('initially empty', () {
        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setToken(token1);
          expect(await storage.getToken(), equals(token1));
          await storage.removeToken();
          expect(await storage.getToken(), isNull);
        });

        group('status operations', () {
          test('status', () {
            expect(
              () async => await storage.status,
              throwsA(isA<UnimplementedError>()),
            );
          });

          test('statusStream', () {
            expect(
              () => storage.statusStream,
              throwsA(isA<UnimplementedError>()),
            );
          });

          test('initializeStatusStream', () {
            expect(
              () async => await storage.initializeStatusStream(),
              throwsA(isA<UnimplementedError>()),
            );
          });
        });
      });
    });

    group('inMemory+locked check locking mechanism', () {
      // todo: not tested yet ...
    });

    group('inMemory+streaming', () {
      group('without initial token', () {
        setUp(() {
          storage = AuthStorage.inMemory().streaming();
        });

        test('status', () async {
          expect(await storage.status, equals(AuthStatus.loggedOut));
        });

        test('statusStream', () {
          expect(storage.statusStream, isNotNull);
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
          await storage.setToken(token1);
          await storage.removeToken();
          await storage.setToken(token1);
          await storage.removeToken();
        });
      });

      group('with initial token', () {
        setUp(() {
          storage = AuthStorage.inMemory();
          storage.setToken(token1);
          storage = storage.streaming();
        });

        test('status', () async {
          expect(await storage.status, equals(AuthStatus.loggedIn));
        });

        test('statusStream', () {
          expect(storage.statusStream, isNotNull);
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
          await storage.setToken(token1);
          await storage.removeToken();
        });
      });
    });

    group('inMemory+streaming+locked', () {
      group('without initial token', () {
        setUp(() {
          storage = AuthStorage.inMemory().streaming().locked();
        });

        test('status', () async {
          expect(await storage.status, equals(AuthStatus.loggedOut));
        });

        test('statusStream', () {
          expect(storage.statusStream, isNotNull);
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
          await storage.setToken(token1);
          await storage.removeToken();
          await storage.setToken(token1);
          await storage.removeToken();
        });
      });

      group('with initial token', () {
        setUp(() {
          storage = AuthStorage.inMemory();
          storage.setToken(token1);
          storage = storage.streaming().locked();
        });

        test('status', () async {
          expect(await storage.status, equals(AuthStatus.loggedIn));
        });

        test('statusStream', () {
          expect(storage.statusStream, isNotNull);
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
          await storage.setToken(token1);
          await storage.removeToken();
        });
      });
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
