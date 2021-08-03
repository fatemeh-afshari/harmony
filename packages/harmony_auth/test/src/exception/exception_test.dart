import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/exception/exception.dart';

void main() {
  group('AuthException', () {
    test('initialization', () {
      final e = AuthException();
      expect(e.toString(), equals('AuthException'));
    });
  });
}
