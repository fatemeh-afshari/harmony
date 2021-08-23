import 'package:flutter_test/flutter_test.dart';
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
              await storage.setTokens(example);
              expect(await storage.status, equals(AuthStatus.loggedIn));
            });
          });
        });

        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setTokens(example);
          expect(await storage.getToken(), equals(example));
          await storage.removeTokens();
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
              await storage.setTokens(example);
              expect(await storage.status, equals(AuthStatus.loggedIn));
            });
          });
        });

        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setTokens(example);
          expect(await storage.getToken(), equals(example));
          await storage.removeTokens();
          expect(await storage.getToken(), isNull);
        });
      });
    });

    group('standard+locked', () {
      setUp(() {
        SharedPreferences.setMockInitialValues({});
        storage = AuthStorage().locked();
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
              await storage.setTokens(example);
              expect(await storage.status, equals(AuthStatus.loggedIn));
            });
          });
        });

        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setTokens(example);
          expect(await storage.getToken(), equals(example));
          await storage.removeTokens();
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
              await storage.setTokens(example);
              expect(await storage.status, equals(AuthStatus.loggedIn));
            });
          });
        });

        test('get initial token', () async {
          expect(await storage.getToken(), isNull);
        });

        test('set, get and remove token', () async {
          await storage.setTokens(example);
          expect(await storage.getToken(), equals(example));
          await storage.removeTokens();
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

        // todo could not test storage exception ...
      });
    });
  });
}
