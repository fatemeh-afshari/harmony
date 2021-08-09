import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/storage/storage.dart';

void main() {
  group('AuthStorage+Status', () {
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

      test('initializeStatusStreamOrNothing', () {
        storage.initializeStatusStreamOrNothing();
      });

      test('initializeStatusStream', () {
        expect(() => storage.initializeStatusStream(), throwsA(anything));
      });
    });

    group('with status', () {
      late AuthStorage storage;

      setUp(() {
        storage = AuthStorage.inMemory().wrapWithStatus();
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

      test('initializeStatusStreamOrNothing', () {
        expect(storage.statusStream, emits(AuthStatus.loggedOut));
        storage.initializeStatusStreamOrNothing();
      });

      test('initializeStatusStream', () {
        expect(storage.statusStream, emits(AuthStatus.loggedOut));
        storage.initializeStatusStream();
      });

      test('status stream', () {
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
        storage.initializeStatusStream();
        storage.setRefreshToken('r1');
        storage.removeRefreshToken();
        storage.setRefreshToken('r2');
        storage.clear();
        storage.setAccessToken('a1');
        storage.removeAccessToken();
      });
    });
  });
}
