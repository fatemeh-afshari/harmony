import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/utils/uri_extensions.dart';

void main() {
  group('AuthUriExtensions', () {
    test('url', () {
      expect(
        Uri.parse('https://test').url,
        equals('https://test'),
      );
      expect(
        Uri.parse('https://test?key=value').url,
        equals('https://test'),
      );
    });
  });
}
