import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/storage/storage.dart';
import 'package:harmony_auth/src/token/token.dart';

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
        await storage.setRefreshToken('r1');
        await storage.removeRefreshToken();
        await storage.setRefreshToken('r2');
        await storage.clear();
        await storage.setAccessToken('a1');
        await storage.removeAccessToken();
        await storage.getAccessToken();
      });
    });
  });
}
