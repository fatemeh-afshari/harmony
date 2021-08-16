import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:mocktail/mocktail.dart';

class MockLog extends Mock implements Log {}

void main() {
  group('LogLevelExt', () {
    late MockLog log;

    setUp(() {
      log = MockLog();
      registerFallbackValue(LogLevel.verbose);
      registerFallbackValue('');
      when(() => log.log(
            level: any(named: 'level'),
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
            extra: any(named: 'extra'),
          )).thenThrow(TestFailure('mock failed'));
    });

    tearDown(() {
      resetMocktailState();
    });

    test('v', () {
      final trace = StackTrace.empty;
      when(() => log.log(
            level: LogLevel.verbose,
            message: 'message',
            error: 'error',
            stackTrace: trace,
            extra: 'extra',
          )).thenAnswer((_) {});
      log.v('message', 'error', trace, 'extra');
    });

    test('d', () {
      final trace = StackTrace.empty;
      when(() => log.log(
            level: LogLevel.debug,
            message: 'message',
            error: 'error',
            stackTrace: trace,
            extra: 'extra',
          )).thenAnswer((_) {});
      log.d('message', 'error', trace, 'extra');
    });

    test('i', () {
      final trace = StackTrace.empty;
      when(() => log.log(
            level: LogLevel.info,
            message: 'message',
            error: 'error',
            stackTrace: trace,
            extra: 'extra',
          )).thenAnswer((_) {});
      log.i('message', 'error', trace, 'extra');
    });

    test('w', () {
      final trace = StackTrace.empty;
      when(() => log.log(
            level: LogLevel.warning,
            message: 'message',
            error: 'error',
            stackTrace: trace,
            extra: 'extra',
          )).thenAnswer((_) {});
      log.w('message', 'error', trace, 'extra');
    });

    test('e', () {
      final trace = StackTrace.empty;
      when(() => log.log(
            level: LogLevel.error,
            message: 'message',
            error: 'error',
            stackTrace: trace,
            extra: 'extra',
          )).thenAnswer((_) {});
      log.e('message', 'error', trace, 'extra');
    });

    test('wtf', () {
      final trace = StackTrace.empty;
      when(() => log.log(
            level: LogLevel.wtf,
            message: 'message',
            error: 'error',
            stackTrace: trace,
            extra: 'extra',
          )).thenAnswer((_) {});
      log.wtf('message', 'error', trace, 'extra');
    });
  });
}
