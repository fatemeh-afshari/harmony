import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/level_extensions.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:mocktail/mocktail.dart';

class MockLog extends Mock implements Log {}

void main() {
  group('Log', () {
    group('LogLevelExt', () {
      late Log log;

      setUp(() {
        log = MockLog();
      });

      tearDown(() {
        resetMocktailState();
      });

      test('v', () {
        final trace = StackTrace.empty;
        log.v('message', error: 'error', stackTrace: trace, extra: 'extra');
        verify(() => log.log(
              LogLevel.verbose,
              'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });

      test('d', () {
        final trace = StackTrace.empty;
        log.d('message', error: 'error', stackTrace: trace, extra: 'extra');
        verify(() => log.log(
              LogLevel.debug,
              'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });

      test('i', () {
        final trace = StackTrace.empty;
        log.i('message', error: 'error', stackTrace: trace, extra: 'extra');
        verify(() => log.log(
              LogLevel.info,
              'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });

      test('w', () {
        final trace = StackTrace.empty;
        log.w('message', error: 'error', stackTrace: trace, extra: 'extra');
        verify(() => log.log(
              LogLevel.warning,
              'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });

      test('e', () {
        final trace = StackTrace.empty;
        log.e('message', error: 'error', stackTrace: trace, extra: 'extra');
        verify(() => log.log(
              LogLevel.error,
              'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });

      test('wtf', () {
        final trace = StackTrace.empty;
        log.wtf('message', error: 'error', stackTrace: trace, extra: 'extra');
        verify(() => log.log(
              LogLevel.wtf,
              'message',
              error: 'error',
              stackTrace: trace,
              extra: 'extra',
            )).called(1);
      });
    });
  });
}
