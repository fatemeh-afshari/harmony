import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/plain/format/format.dart';

void main() {
  group('LogPlainFormat', () {
    group('json', () {
      group('format', () {
        test('complete', () {
          final formatter = LogPlainFormat.json();
          final time = DateTime.now();
          final event = LogEvent(
            id: 'id',
            time: time,
            tag: 'tag',
            level: LogLevel.warning,
            message: 'message',
            error: 'error',
            stackTrace: StackTrace.empty,
            extra: 'extra',
          );
          final format = formatter.format(event);
          expect(format, hasLength(1));
          expect(
              format.first,
              equals(
                '{"id":"id","time":"${time.toIso8601String()}",'
                '"tag":"tag","level":"warning","message":"message",'
                '"error":"error","stackTrace":"","extra":"extra"},',
              ));
        });

        test('partial', () {
          final formatter = LogPlainFormat.json();
          final time = DateTime.now();
          final event = LogEvent(
            id: 'id',
            time: time,
            level: LogLevel.warning,
            message: 'message',
          );
          final format = formatter.format(event);
          expect(format, hasLength(1));
          expect(
              format.first,
              equals(
                '{"id":"id","time":"${time.toIso8601String()}",'
                '"tag":null,"level":"warning","message":"message",'
                '"error":null,"stackTrace":null,"extra":null},',
              ));
        });
      });
    });
  });
}
