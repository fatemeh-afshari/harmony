import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AuthStorage', () {
    group('standard', () {
      group('initialize with mocked empty storage', () {
        late AuthStorage storage;

        setUp(() {
          SharedPreferences.setMockInitialValues({});
          storage = AuthStorage.standard();
        });

        test('check initial data', () async {
          expect(await storage.getAccessToken(), isNull);
          expect(await storage.getRefreshToken(), isNull);
        });

        test('check access token', () async {
          await storage.setAccessToken('a');
          expect(await storage.getAccessToken(), equals('a'));
          await storage.removeAccessToken();
          expect(await storage.getAccessToken(), isNull);
        });

        test('check refresh token', () async {
          await storage.setRefreshToken('r');
          expect(await storage.getRefreshToken(), equals('r'));
          await storage.removeRefreshToken();
          expect(await storage.getRefreshToken(), isNull);
        });

        test('check clear tokens', () async {
          await storage.setAccessToken('a');
          await storage.setRefreshToken('r');
          await storage.clear();
          expect(await storage.getAccessToken(), isNull);
          expect(await storage.getRefreshToken(), isNull);
        });
      });
    });

    group('inMemory', () {
      group('AuthStorageExt', () {
        test('isLoggedIn', () async {
          final storage = AuthStorage.inMemory();
          expect(await storage.status, equals(AuthStatus.loggedOut));
          await storage.setRefreshToken('r1');
          expect(await storage.status, equals(AuthStatus.loggedIn));
        });
      });

      group('initialize with empty storage', () {
        late AuthStorage storage;

        setUp(() {
          storage = AuthStorage.inMemory();
        });

        test('check initial data', () async {
          expect(await storage.getAccessToken(), isNull);
          expect(await storage.getRefreshToken(), isNull);
        });

        test('check access token', () async {
          await storage.setAccessToken('a');
          expect(await storage.getAccessToken(), equals('a'));
          await storage.removeAccessToken();
          expect(await storage.getAccessToken(), isNull);
        });

        test('check refresh token', () async {
          await storage.setRefreshToken('r');
          expect(await storage.getRefreshToken(), equals('r'));
          await storage.removeRefreshToken();
          expect(await storage.getRefreshToken(), isNull);
        });

        test('check clear tokens', () async {
          await storage.setAccessToken('a');
          await storage.setRefreshToken('r');
          await storage.clear();
          expect(await storage.getAccessToken(), isNull);
          expect(await storage.getRefreshToken(), isNull);
        });
      });
    });
  });
}
