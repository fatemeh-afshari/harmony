import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/matcher/matcher.dart';

void main() {
  group('AuthMatcher', () {
    test('implementation all', () {
      final matcher = AuthMatcher.all();
      expect(matcher.matches('a', 'b'), isTrue);
    });

    test('implementation none', () {
      final matcher = AuthMatcher.none();
      expect(matcher.matches('a', 'b'), isFalse);
    });

    group('implementation url', () {
      test('with String', () {
        final matcher = AuthMatcher.url('u');
        expect(matcher.matches('m', 'u'), isTrue);
        expect(matcher.matches('m', 'x'), isFalse);
      });

      test('with Regex', () {
        final matcher = AuthMatcher.url(RegExp('[uv]'));
        expect(matcher.matches('m', 'u'), isTrue);
        expect(matcher.matches('m', 'v'), isTrue);
        expect(matcher.matches('m', 'x'), isFalse);
      });
    });

    group('implementation urls', () {
      test('with String', () {
        final matcher = AuthMatcher.urls({'u1', 'u2'});
        expect(matcher.matches('m', 'u1'), isTrue);
        expect(matcher.matches('m', 'u2'), isTrue);
        expect(matcher.matches('m', 'x'), isFalse);
      });

      test('with Regex', () {
        final matcher = AuthMatcher.urls({
          RegExp('[uv]1'),
          'u2',
        });
        expect(matcher.matches('m', 'u1'), isTrue);
        expect(matcher.matches('m', 'v1'), isTrue);
        expect(matcher.matches('m', 'u2'), isTrue);
        expect(matcher.matches('m', 'x'), isFalse);
      });
    });

    test('implementation baseUrl', () {
      final matcher = AuthMatcher.baseUrl('u');
      expect(matcher.matches('m', 'u'), isTrue);
      expect(matcher.matches('m', 'ufo'), isTrue);
      expect(matcher.matches('m', 'x'), isFalse);
    });

    test('implementation baseUrls', () {
      final matcher = AuthMatcher.baseUrls({'u1', 'u2'});
      expect(matcher.matches('m', 'u1'), isTrue);
      expect(matcher.matches('m', 'u1 hello'), isTrue);
      expect(matcher.matches('m', 'u2'), isTrue);
      expect(matcher.matches('m', 'u2 hello'), isTrue);
      expect(matcher.matches('m', 'ufo'), isFalse);
    });

    group('implementation method', () {
      test('with String', () {
        final matcher = AuthMatcher.method('m');
        expect(matcher.matches('m', 'u'), isTrue);
        expect(matcher.matches('x', 'u'), isFalse);
      });

      test('with Regex', () {
        final matcher = AuthMatcher.method(RegExp('[mn]'));
        expect(matcher.matches('m', 'u'), isTrue);
        expect(matcher.matches('n', 'u'), isTrue);
        expect(matcher.matches('x', 'u'), isFalse);
      });
    });

    group('implementation methods', () {
      test('with String', () {
        final matcher = AuthMatcher.methods({'m1', 'm2'});
        expect(matcher.matches('m1', 'u'), isTrue);
        expect(matcher.matches('m2', 'u'), isTrue);
        expect(matcher.matches('x', 'u'), isFalse);
      });

      test('with Regex', () {
        final matcher = AuthMatcher.methods({
          RegExp('[mn]1'),
          'm2',
        });
        expect(matcher.matches('m1', 'u'), isTrue);
        expect(matcher.matches('n1', 'u'), isTrue);
        expect(matcher.matches('m2', 'u'), isTrue);
        expect(matcher.matches('x', 'u'), isFalse);
      });
    });

    test('implementation byUrl', () {
      final matcher = AuthMatcher.byUrl((url) => url == 'u');
      expect(matcher.matches('m', 'u'), isTrue);
      expect(matcher.matches('m', 'v'), isFalse);
    });

    test('implementation byMethod', () {
      final matcher = AuthMatcher.byMethod((method) => method == 'm');
      expect(matcher.matches('m', 'u'), isTrue);
      expect(matcher.matches('n', 'u'), isFalse);
    });

    test('implementation byMethodAndUrl', () {
      final matcher = AuthMatcher.byMethodAndUrl(
        (method, url) => method == 'm' && url == 'u',
      );
      expect(matcher.matches('m', 'u'), isTrue);
      expect(matcher.matches('m', 'v'), isFalse);
      expect(matcher.matches('n', 'u'), isFalse);
      expect(matcher.matches('n', 'v'), isFalse);
    });

    group('operations', () {
      test('union', () {
        final matcher = AuthMatcher.method('m') | AuthMatcher.url('u');
        expect(matcher.matches('m', 'u'), isTrue);
        expect(matcher.matches('n', 'u'), isTrue);
        expect(matcher.matches('m', 'v'), isTrue);
        expect(matcher.matches('n', 'v'), isFalse);
      });

      test('intersection', () {
        final matcher = AuthMatcher.method('m') & AuthMatcher.url('u');
        expect(matcher.matches('m', 'u'), isTrue);
        expect(matcher.matches('n', 'u'), isFalse);
        expect(matcher.matches('m', 'v'), isFalse);
        expect(matcher.matches('n', 'v'), isFalse);
      });

      test('difference', () {
        final matcher = AuthMatcher.method('m') - AuthMatcher.url('u');
        expect(matcher.matches('m', 'u'), isFalse);
        expect(matcher.matches('n', 'u'), isFalse);
        expect(matcher.matches('m', 'v'), isTrue);
        expect(matcher.matches('n', 'v'), isFalse);
      });

      test('symmetric difference', () {
        final matcher = AuthMatcher.method('m') ^ AuthMatcher.url('u');
        expect(matcher.matches('m', 'u'), isFalse);
        expect(matcher.matches('n', 'u'), isTrue);
        expect(matcher.matches('m', 'v'), isTrue);
        expect(matcher.matches('n', 'v'), isFalse);
      });

      test('negate', () {
        final matcher = -AuthMatcher.method('m');
        expect(matcher.matches('m', 'u'), isFalse);
        expect(matcher.matches('n', 'u'), isTrue);
      });
    });
  });
}
