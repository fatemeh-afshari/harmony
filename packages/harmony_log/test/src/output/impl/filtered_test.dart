import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/filter.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:mocktail/mocktail.dart';

class FakeLogEvent extends Fake implements LogEvent {}

class MockLogOutput extends Mock implements LogOutput {}

class MockLogFilter extends Mock implements LogFilter {}

void main() {
  group('LogOutput', () {
    group('filtered', () {
      late LogOutput child;
      late LogOutput output;
      late LogFilter filter;

      setUp(() {
        child = MockLogOutput();
        filter = MockLogFilter();
        output = LogOutput.filtered(
          filter: filter,
          child: child,
        );
      });

      tearDown(() {
        verifyNoMoreInteractions(child);
        resetMocktailState();
      });

      test('init', () {
        output.init();
        verify(() => child.init()).called(1);
      });

      group('write', () {
        test('logging', () {
          final event = FakeLogEvent();
          when(() => filter.shouldLog(event)).thenReturn(true);
          output.write(event);
          verify(() => child.write(event)).called(1);
        });

        test('non-logging', () {
          final event = FakeLogEvent();
          when(() => filter.shouldLog(event)).thenReturn(false);
          output.write(event);
        });
      });

      test('close', () {
        output.close();
        verify(() => child.close()).called(1);
      });
    });
  });
}
