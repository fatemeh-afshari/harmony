import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/plain/format/format.dart';

void main() {
  group('LogPlainFormat', () {
    group('simple', () {
      group('format', () {
        test('basic', () {
          final format = LogPlainFormat.simple(
            prefix: 'ABC ',
          );
          final time = DateTime.now();
          final event = LogEvent(
            id: 'id',
            time: time,
            level: LogLevel.debug,
            message: 'messaging',
          );
          final list = format.format(event);
          expect(list, hasLength(1));
          expect(
            list.first,
            equals('ABC ${time.toIso8601String()} [D] messaging'),
          );
        });

        test('default prefix', () {
          final format = LogPlainFormat.simple();
          final time = DateTime.now();
          final event = LogEvent(
            id: 'id',
            time: time,
            level: LogLevel.debug,
            message: 'messaging',
          );
          final list = format.format(event);
          expect(list, hasLength(1));
          expect(
            list.first,
            equals('LOG ${time.toIso8601String()} [D] messaging'),
          );
        });

        test('with tag', () {
          final format = LogPlainFormat.simple(
            prefix: 'ABC ',
          );
          final time = DateTime.now();
          final event = LogEvent(
            id: 'id',
            time: time,
            level: LogLevel.debug,
            message: 'messaging',
            tag: 'TAG',
          );
          final list = format.format(event);
          expect(list, hasLength(1));
          expect(
            list.first,
            equals('ABC ${time.toIso8601String()} TAG [D] messaging'),
          );
        });

        test('with error', () {
          final format = LogPlainFormat.simple(
            prefix: 'ABC ',
          );
          final time = DateTime.now();
          final error = AssertionError();
          final event = LogEvent(
            id: 'id',
            time: time,
            level: LogLevel.debug,
            message: 'messaging',
            error: error,
          );
          final list = format.format(event);
          expect(list, hasLength(1));
          expect(
            list.first,
            equals('ABC ${time.toIso8601String()} [D] messaging ERROR=$error'),
          );
        });

        test('complete', () {
          final format = LogPlainFormat.simple(
            prefix: 'ABC ',
          );
          final time = DateTime.now();
          final error = AssertionError();
          final event = LogEvent(
            id: 'id',
            time: time,
            level: LogLevel.debug,
            message: 'messaging',
            tag: 'TAG',
            error: error,
            extra: 'EXTRA',
            stackTrace: StackTrace.empty,
          );
          final list = format.format(event);
          expect(list, hasLength(1));
          expect(
            list.first,
            equals(
              'ABC ${time.toIso8601String()} TAG [D] messaging ERROR=$error',
            ),
          );
        });
      });
    });
  });
}
