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
  });
}
