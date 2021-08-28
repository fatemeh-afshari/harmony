import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:mocktail/mocktail.dart';

class MockLog extends Mock implements Log {}

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('Log', () {
    group('tagged', () {
      late Log base;
      late Log log;

      setUp(() {
        base = MockLog();
        log = Log.tagged(tag: 'TAG', child: base);
      });

      tearDown(() {
        resetMocktailState();
      });

      test('init', () {
        log.init();
        verify(() => base.init()).called(1);
      });

      test('close', () {
        log.close();
        verify(() => base.close()).called(1);
      });

      test('tag', () {
        expect(log.tag, equals('TAG'));
        verifyNever(() => base.tag);
      });

      test('write', () {
        final event = FakeLogEvent();
        log.write(event);
        verify(() => base.write(event)).called(1);
      });

      test('log', () {
        final trace = StackTrace.empty;
        log.log(
          LogLevel.warning,
          'message',
          error: 'error',
          stackTrace: trace,
          extra: 'extra',
        );
        verify(() => base.log(
              LogLevel.warning,
              'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });
    });

    group('LogTagExt', () {
      late Log base;
      late Log log;

      setUp(() {
        base = MockLog();
        log = base.tagged('TAG');
      });

      tearDown(() {
        resetMocktailState();
      });

      test('init', () {
        log.init();
        verify(() => base.init()).called(1);
      });

      test('close', () {
        log.close();
        verify(() => base.close()).called(1);
      });

      test('tag', () {
        expect(log.tag, equals('TAG'));
        verifyNever(() => base.tag);
      });

      test('write', () {
        final event = FakeLogEvent();
        log.write(event);
        verify(() => base.write(event)).called(1);
      });

      test('log', () {
        final trace = StackTrace.empty;
        log.log(
          LogLevel.warning,
          'message',
          error: 'error',
          stackTrace: trace,
          extra: 'extra',
        );
        verify(() => base.log(
              LogLevel.warning,
              'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });
    });
  });
}
