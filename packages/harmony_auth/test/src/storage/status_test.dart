import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/storage/storage.dart';
import 'package:harmony_auth/src/token/token.dart';
import 'package:mocktail/mocktail.dart';

class FakeAuthToken extends Fake implements AuthToken {}

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
          await storage.setTokens(FakeAuthToken());
          await storage.removeTokens();
          await storage.setTokens(FakeAuthToken());
          await storage.removeTokens();
        });
      });

      group('with initial token', () {
        setUp(() {
          storage = AuthStorage.inMemory();
          storage.setTokens(FakeAuthToken());
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
          await storage.removeTokens();
          await storage.setTokens(FakeAuthToken());
          await storage.removeTokens();
        });
      });
    });
  });
}
