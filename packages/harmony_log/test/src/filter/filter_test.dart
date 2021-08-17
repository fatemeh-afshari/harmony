import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/filter.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:mocktail/mocktail.dart';

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('LogFilter', () {
    test('general impl', () {
      final filter = LogFilter.general((e) => e.message == 'a');
      expect(
        filter.shouldLog(LogEvent(
          id: 'id',
          time: DateTime.now(),
          tag: 'tag',
          level: LogLevel.wtf,
          message: 'a',
          error: 'error',
          stackTrace: StackTrace.empty,
          extra: 'extra',
        )),
        isTrue,
      );
      expect(
        filter.shouldLog(LogEvent(
          id: 'id',
          time: DateTime.now(),
          tag: 'tag',
          level: LogLevel.wtf,
          message: 'b',
          error: 'error',
          stackTrace: StackTrace.empty,
          extra: 'extra',
        )),
        isFalse,
      );
    });

    test('level impl', () {
      final filter = LogFilter.level(LogLevel.warning);
      expect(
        filter.shouldLog(LogEvent(
          id: 'id',
          time: DateTime.now(),
          tag: 'tag',
          level: LogLevel.wtf,
          message: 'message',
          error: 'error',
          stackTrace: StackTrace.empty,
          extra: 'extra',
        )),
        isTrue,
      );
      expect(
        filter.shouldLog(LogEvent(
          id: 'id',
          time: DateTime.now(),
          tag: 'tag',
          level: LogLevel.warning,
          message: 'message',
          error: 'error',
          stackTrace: StackTrace.empty,
          extra: 'extra',
        )),
        isTrue,
      );
      expect(
        filter.shouldLog(LogEvent(
          id: 'id',
          time: DateTime.now(),
          tag: 'tag',
          level: LogLevel.verbose,
          message: 'message',
          error: 'error',
          stackTrace: StackTrace.empty,
          extra: 'extra',
        )),
        isFalse,
      );
    });

    test('exactLevel impl', () {
      final filter = LogFilter.exactLevel(LogLevel.warning);
      expect(
        filter.shouldLog(LogEvent(
          id: 'id',
          time: DateTime.now(),
          tag: 'tag',
          level: LogLevel.wtf,
          message: 'message',
          error: 'error',
          stackTrace: StackTrace.empty,
          extra: 'extra',
        )),
        isFalse,
      );
      expect(
        filter.shouldLog(LogEvent(
          id: 'id',
          time: DateTime.now(),
          tag: 'tag',
          level: LogLevel.warning,
          message: 'message',
          error: 'error',
          stackTrace: StackTrace.empty,
          extra: 'extra',
        )),
        isTrue,
      );
      expect(
        filter.shouldLog(LogEvent(
          id: 'id',
          time: DateTime.now(),
          tag: 'tag',
          level: LogLevel.verbose,
          message: 'message',
          error: 'error',
          stackTrace: StackTrace.empty,
          extra: 'extra',
        )),
        isFalse,
      );
    });

    test('all impl', () {
      expect(
        LogFilter.all().shouldLog(FakeLogEvent()),
        isTrue,
      );
    });

    test('none impl', () {
      expect(
        LogFilter.none().shouldLog(FakeLogEvent()),
        isFalse,
      );
    });

    test('debug impl', () {
      expect(
        LogFilter.debug().shouldLog(FakeLogEvent()),
        equals(kDebugMode),
      );
    });

    test('release impl', () {
      expect(
        LogFilter.release().shouldLog(FakeLogEvent()),
        equals(kReleaseMode),
      );
    });

    test('profile impl', () {
      expect(
        LogFilter.profile().shouldLog(FakeLogEvent()),
        equals(kProfileMode),
      );
    });

    group('set operations', () {
      LogFilter message(String message) => LogFilter.general(
            (e) => e.message == message,
          );
      LogFilter tag(String tag) => LogFilter.general(
            (e) => e.tag == tag,
          );
      LogEvent event(String message, String tag) => LogEvent(
            id: 'id',
            time: DateTime.now(),
            tag: tag,
            level: LogLevel.wtf,
            message: message,
            error: 'error',
            stackTrace: StackTrace.empty,
            extra: 'extra',
          );

      test('union', () {
        final f = message('m') | tag('u');
        expect(f.shouldLog(event('m', 'u')), isTrue);
        expect(f.shouldLog(event('n', 'u')), isTrue);
        expect(f.shouldLog(event('m', 'v')), isTrue);
        expect(f.shouldLog(event('n', 'v')), isFalse);
      });

      test('intersection', () {
        final f = message('m') & tag('u');
        expect(f.shouldLog(event('m', 'u')), isTrue);
        expect(f.shouldLog(event('n', 'u')), isFalse);
        expect(f.shouldLog(event('m', 'v')), isFalse);
        expect(f.shouldLog(event('n', 'v')), isFalse);
      });

      test('difference', () {
        final f = message('m') - tag('u');
        expect(f.shouldLog(event('m', 'u')), isFalse);
        expect(f.shouldLog(event('n', 'u')), isFalse);
        expect(f.shouldLog(event('m', 'v')), isTrue);
        expect(f.shouldLog(event('n', 'v')), isFalse);
      });

      test('symmetric difference', () {
        final f = message('m') ^ tag('u');
        expect(f.shouldLog(event('m', 'u')), isFalse);
        expect(f.shouldLog(event('n', 'u')), isTrue);
        expect(f.shouldLog(event('m', 'v')), isTrue);
        expect(f.shouldLog(event('n', 'v')), isFalse);
      });

      test('negate', () {
        final f = -message('m');
        expect(f.shouldLog(event('m', 'u')), isFalse);
        expect(f.shouldLog(event('n', 'u')), isTrue);
      });
    });
  });
}
