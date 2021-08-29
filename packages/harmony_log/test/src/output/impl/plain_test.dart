import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:harmony_log/src/plain/format/format.dart';
import 'package:harmony_log/src/plain/output/output.dart';
import 'package:mocktail/mocktail.dart';

class MockLogPlainFormat extends Mock implements LogPlainFormat {}

class MockLogPlainOutput extends Mock implements LogPlainOutput {}

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('LogOutput', () {
    group('plain', () {
      late LogPlainFormat pf;
      late LogPlainOutput po;
      late LogOutput output;

      setUp(() {
        registerFallbackValue(FakeLogEvent());
        pf = MockLogPlainFormat();
        po = MockLogPlainOutput();
        output = LogOutput.plain(format: pf, child: po);
      });

      tearDown(() {
        verifyNoMoreInteractions(pf);
        verifyNoMoreInteractions(po);
        resetMocktailState();
      });

      test('init', () {
        output.init();
        verify(() => po.init()).called(1);
      });

      test('write', () {
        final event = FakeLogEvent();
        final x = ['a', 'b'];
        when(() => pf.format(event)).thenReturn(x);
        output.write(event);
        verify(() => pf.format(event)).called(1);
        verify(() => po.write(x)).called(1);
      });

      test('close', () {
        output.close();
        verify(() => po.close()).called(1);
      });
    });
  });
}
