import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';

void main() {
  group('Log', () {
    group('noop', () {
      late Log log;

      setUp(() {
        log = Log.noop();
      });

      test('init', () {
        log.init();
      });

      test('close', () {
        log.close();
      });

      test('log', () {
        final trace = StackTrace.empty;
        log.log(
          level: LogLevel.warning,
          message: 'message',
          error: 'error',
          stackTrace: trace,
          extra: 'extra',
        );
      });

      test('write', () {
        final trace = StackTrace.empty;
        log.write(LogEvent(
          id: 'id',
          time: DateTime.now(),
          tag: 'tag',
          level: LogLevel.warning,
          message: 'message',
          error: 'error',
          stackTrace: trace,
          extra: 'extra',
        ));
      });
    });
  });
}
