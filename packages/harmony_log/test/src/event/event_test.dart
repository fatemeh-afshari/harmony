import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('LogEvent', () {
    test('initialization', () {
      final time = DateTime.now();
      final trace = StackTrace.empty;
      final event = LogEvent(
        id: 'id',
        time: time,
        tag: 'tag',
        level: LogLevel.wtf,
        message: 'message',
        error: 'error',
        stackTrace: trace,
        extra: 'extra',
      );
      expect(event.id, equals('id'));
      expect(event.time, equals(time));
      expect(event.tag, equals('tag'));
      expect(event.level, equals(LogLevel.wtf));
      expect(event.message, equals('message'));
      expect(event.error, equals('error'));
      expect(event.stackTrace, equals(trace));
      expect(event.extra, equals('extra'));
    });

    test('generate', () {
      final trace = StackTrace.empty;
      final event = LogEvent.generate(
        tag: 'tag',
        level: LogLevel.wtf,
        message: 'message',
        error: 'error',
        stackTrace: trace,
        extra: 'extra',
      );
      expect(Uuid.isValidUUID(fromString: event.id), isTrue);
      expect(event.time, isA<DateTime>());
      expect(event.tag, equals('tag'));
      expect(event.level, equals(LogLevel.wtf));
      expect(event.message, equals('message'));
      expect(event.error, equals('error'));
      expect(event.stackTrace, equals(trace));
      expect(event.extra, equals('extra'));
    });
  });
}
