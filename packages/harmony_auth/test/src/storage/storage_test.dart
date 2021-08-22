import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/storage/storage.dart';
import 'package:harmony_auth/src/token/token.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthToken extends Fake implements AuthToken {}

void main() {
  group('AuthStorage', () {
    group('standard', () {
      group('initialize with mocked empty storage', () {
        late AuthStorage storage;

        setUp(() {
          SharedPreferences.setMockInitialValues({});
          storage = AuthStorage();
        });

        test('check initial data', () async {
          expect(await storage.geToken(), isNull);
        });

        test('check token', () async {
          final token = FakeAuthToken();
          await storage.setTokens(token);
          expect(await storage.geToken(), equals(token));
          await storage.removeTokens();
          expect(await storage.geToken(), isNull);
        });
      });
    });

    group('inMemory', () {
      group('AuthStorageExt', () {
        test('isLoggedIn', () async {
          final storage = AuthStorage.inMemory();
          expect(await storage.status, equals(AuthStatus.loggedOut));
          await storage.setTokens(FakeAuthToken());
          expect(await storage.status, equals(AuthStatus.loggedIn));
        });
      });

      group('initialize with empty storage', () {
        late AuthStorage storage;

        setUp(() {
          storage = AuthStorage.inMemory();
        });

        test('check initial data', () async {
          expect(await storage.geToken(), isNull);
        });

        test('check token', () async {
          final token = FakeAuthToken();
          await storage.setTokens(token);
          expect(await storage.geToken(), equals(token));
          await storage.removeTokens();
          expect(await storage.geToken(), isNull);
        });
      });
    });
  });
}
