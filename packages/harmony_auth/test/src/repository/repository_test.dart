import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/matcher/matcher.dart';
import 'package:harmony_auth/src/repository/impl/impl.dart';
import 'package:harmony_auth/src/repository/repository.dart';
import 'package:harmony_auth/src/rest/rest.dart';
import 'package:harmony_auth/src/storage/storage.dart';
import 'package:harmony_auth/src/token/token.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRest extends Mock implements AuthRest {}

class FakeAuthMatcher extends Fake implements AuthMatcher {}

const refreshUrl = 'https://refresh';

const token1 = AuthToken(refresh: 'r1', access: 'a1');
const token2 = AuthToken(refresh: 'r2', access: 'a2');

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
    });

    tearDown(() {
      resetMocktailState();
    });

    group('standard', () {
      setUp(() {
        repository = AuthRepository(
          storage: storage,
          rest: rest,
        );
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

      group('refreshTokens', () {});
    });
  });
}
