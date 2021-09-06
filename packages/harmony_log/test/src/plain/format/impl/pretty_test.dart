import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/plain/format/format.dart';

void main() {
  group('LogPlainFormat', () {
    group('pretty', () {
      test('start', () {
        final formatter = LogPlainFormat.pretty();
        final x = formatter.start();
        expect(x, hasLength(0));
      });

      test('end', () {
        final formatter = LogPlainFormat.pretty();
        final x = formatter.end();
        expect(x, hasLength(0));
      });

      group('format', () {
        test('complete', () {
          final formatter = LogPlainFormat.pretty(prefix: 'PRE-');
          final time = DateTime.now();
          final event = LogEvent(
            id: 'id',
            time: time,
            tag: 'TAG',
            level: LogLevel.wtf,
            message: 'message',
            error: 'error',
            stackTrace: StackTrace.empty,
            extra: 'extra',
          );
          final format = formatter.format(event);
          expect(format, hasLength(9));
          expect(
            format,
            containsAllInOrder(<Matcher>[
              stringContainsInOrder([
                'PRE-',
                'TAG',
                'WTF',
                time.toIso8601String(),
              ]),
              stringContainsInOrder(['PRE-', 'TAG', 'WTF', 'message']),
              stringContainsInOrder(['PRE-', 'TAG', 'WTF', 'error']),
              stringContainsInOrder(['PRE-', 'TAG', 'WTF']),
            ]),
          );
        });

        test('partial', () {
          final formatter = LogPlainFormat.pretty(prefix: 'PRE-');
          final time = DateTime.now();
          final event = LogEvent(
            id: 'id',
            time: time,
            level: LogLevel.wtf,
            message: 'message',
          );
          final format = formatter.format(event);
          expect(format, hasLength(5));
          expect(
            format,
            containsAllInOrder(<Matcher>[
              stringContainsInOrder([
                'PRE-',
                'WTF',
                time.toIso8601String(),
              ]),
              stringContainsInOrder(['PRE-', 'WTF', 'message']),
            ]),
          );
        });
      });
    });
  });
}
