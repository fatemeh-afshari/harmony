import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/token/token.dart';

void main() {
  group('AuthToken', () {
    test('initialization', () {
      final token = AuthToken(refresh: 'r1', access: 'a1');
      expect(token.refresh, equals('r1'));
      expect(token.access, equals('a1'));
    });
  });
}
