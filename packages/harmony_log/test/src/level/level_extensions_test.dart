import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/level/level.dart';

void main() {
  group('LogLevel', () {
    group('LogLevelComparisonExt', () {
      const small = LogLevel.verbose;
      const big = LogLevel.wtf;

      test('compareTo', () {
        expect(small.significance, equals(0));
        expect(big.significance, equals(5));
      });

      test('compareTo', () {
        expect(big.compareTo(big), equals(0));
        expect(big.compareTo(small), greaterThan(0));
        expect(small.compareTo(big), lessThan(0));
      });

      test('>=', () {
        expect(big >= big, isTrue);
        expect(big >= small, isTrue);
        expect(small >= big, isFalse);
      });

      test('>', () {
        expect(big > big, isFalse);
        expect(big > small, isTrue);
        expect(small > big, isFalse);
      });

      test('<', () {
        expect(big < big, isFalse);
        expect(big < small, isFalse);
        expect(small < big, isTrue);
      });

      test('<=', () {
        expect(big <= big, isTrue);
        expect(big <= small, isFalse);
        expect(small <= big, isTrue);
      });
    });
  });
}
