import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:mocktail/mocktail.dart';

class MockLog extends Mock implements Log {}

void main() {
  group('Log', () {
    group('LogLevelExt', () {
      late MockLog log;

      setUp(() {
        log = MockLog();
      });

      tearDown(() {
        resetMocktailState();
      });

      test('v', () {
        final trace = StackTrace.empty;
        log.v('message', 'error', trace, 'extra');
        verify(() => log.log(
              level: LogLevel.verbose,
              message: 'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });

      test('d', () {
        final trace = StackTrace.empty;
        log.d('message', 'error', trace, 'extra');
        verify(() => log.log(
              level: LogLevel.debug,
              message: 'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });

      test('i', () {
        final trace = StackTrace.empty;
        log.i('message', 'error', trace, 'extra');
        verify(() => log.log(
              level: LogLevel.info,
              message: 'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });

      test('w', () {
        final trace = StackTrace.empty;
        log.w('message', 'error', trace, 'extra');
        verify(() => log.log(
              level: LogLevel.warning,
              message: 'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });

      test('e', () {
        final trace = StackTrace.empty;
        log.e('message', 'error', trace, 'extra');
        verify(() => log.log(
              level: LogLevel.error,
              message: 'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });

      test('wtf', () {
        final trace = StackTrace.empty;
        log.wtf('message', 'error', trace, 'extra');
        verify(() => log.log(
              level: LogLevel.wtf,
              message: 'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });
    });
  });
}
