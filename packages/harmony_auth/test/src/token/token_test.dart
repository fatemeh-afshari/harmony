import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/token/token.dart';

void main() {
  group('AuthToken', () {
    test('initialization', () {
      final token = AuthToken(refresh: 'r1', access: 'a1');
      expect(token.refresh, equals('r1'));
      expect(token.access, equals('a1'));
    });

    test('equals', () {
      final token1 = AuthToken(refresh: 'r1', access: 'a1');
      final token2 = AuthToken(refresh: 'r1', access: 'a1');
      final token3 = AuthToken(refresh: 'r2', access: 'a1');
      final token4 = AuthToken(refresh: 'r2', access: 'a2');
      final token5 = AuthToken(refresh: 'r1', access: 'a2');
      expect(token1, equals(token1));
      expect(token2, equals(token1));
      expect(token3, isNot(equals(token1)));
      expect(token4, isNot(equals(token1)));
      expect(token5, isNot(equals(token1)));
    });

    test('hashCode', () {
      final token1 = AuthToken(refresh: 'r1', access: 'a1');
      final token2 = AuthToken(refresh: 'r1', access: 'a1');
      final token3 = AuthToken(refresh: 'r2', access: 'a2');
      expect(token1.hashCode, equals(token1.hashCode));
      expect(token2.hashCode, equals(token1.hashCode));
      expect(token3.hashCode, isNot(equals(token1.hashCode)));
    });

    test('toString', () {
      final token1 = AuthToken(refresh: 'r1', access: 'a1');
      expect(
        token1.toString(),
        allOf(
          stringContainsInOrder(['refresh', 'r1']),
          stringContainsInOrder(['access', 'a1']),
        ),
      );
    });
  });
}
