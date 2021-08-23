import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/repository/impl/impl.dart';
import 'package:harmony_auth/src/repository/repository.dart';

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
}
