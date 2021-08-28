import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:mocktail/mocktail.dart';

class MockLog extends Mock implements Log {}

void main() {
  group('Log', () {
    group('LogTagExt', () {
      late MockLog base;
      late Log log;

      setUp(() {
        base = MockLog();
        log = base.tagged('TAG');
      });

      tearDown(() {
        resetMocktailState();
      });

      test('init', () {
        when(() => base.init()).thenAnswer((_) {});
        log.init();
        verify(() => base.init()).called(1);
      });

      test('close', () {
        when(() => base.close()).thenAnswer((_) {});
        log.close();
        verify(() => base.close()).called(1);
      });

      test('tag', () {
        expect(log.tag, equals('TAG'));
        verifyNever(() => base.tag);
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
