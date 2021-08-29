import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:mocktail/mocktail.dart';

class MockLogOutput extends Mock implements LogOutput {}

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('Log', () {
    group('standard', () {
      late LogOutput output;
      late Log log;

      setUp(() {
        registerFallbackValue(FakeLogEvent());
        output = MockLogOutput();
        log = Log(output: output);
      });

      tearDown(() {
        verifyNoMoreInteractions(output);
        resetMocktailState();
      });

      test('init', () {
        log.init();
        verify(() => output.init()).called(1);
      });

      test('write', () {
        final event = FakeLogEvent();
        log.write(event);
        verify(() => output.write(event)).called(1);
      });

      test('close', () {
        log.init();
        verify(() => output.init()).called(1);
      });
    });
  });
}
