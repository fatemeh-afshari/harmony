import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/plain/format/format.dart';

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('LogPlainFormat', () {
    group('custom', () {
      test('format', () {
        final e = FakeLogEvent();
        final list = ['abc', 'def'];
        dynamic x;
        final format = LogPlainFormat.custom(
          format: (event) {
            x = event;
            return list;
          },
          start: () => throw 'fail',
          end: () => throw 'fail',
        );
        expect(format.format(e), equals(list));
        expect(x, equals(e));
      });

      group('start', () {
        test('non-null', () {
          final list = ['a', 'b'];
          final format = LogPlainFormat.custom(
            start: () => list,
            format: (_) => throw 'fail',
            end: () => throw 'fail',
          );
          expect(format.start(), equals(list));
        });

        test('null', () {
          final format = LogPlainFormat.custom(
            start: null,
            format: (_) => throw 'fail',
            end: () => throw 'fail',
          );
          expect(format.start(), hasLength(0));
        });
      });

      group('end', () {
        test('non-null', () {
          final list = ['a', 'b'];
          final format = LogPlainFormat.custom(
            end: () => list,
            format: (_) => throw 'fail',
            start: () => throw 'fail',
          );
          expect(format.end(), equals(list));
        });

        test('null', () {
          final format = LogPlainFormat.custom(
            end: null,
            format: (_) => throw 'fail',
            start: () => throw 'fail',
          );
          expect(format.end(), hasLength(0));
        });
      });
    });
  });
}
