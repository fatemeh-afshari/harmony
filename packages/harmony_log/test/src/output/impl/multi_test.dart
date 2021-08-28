import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:mocktail/mocktail.dart';

class FakeLogEvent extends Fake implements LogEvent {}

class MockLogOutput extends Mock implements LogOutput {}

void main() {
  group('LogOutput', () {
    group('multi', (){
      group('empty', () {

      });
    });
    group('with two', () {
      late MockLogOutput mock1;
      late MockLogOutput mock2;
      late LogOutput output;

      setUp(() {
        mock1 = MockLogOutput();
        mock2 = MockLogOutput();
        output = LogOutput.multi([mock1, mock2]);
      });

      tearDown(() {
        verifyNoMoreInteractions(mock1);
        verifyNoMoreInteractions(mock2);
        resetMocktailState();
      });

      test('init', () {
        output.init();
        verify(() => mock1.init()).called(1);
        verify(() => mock2.init()).called(1);
      });

      test('write', () {
        final event = FakeLogEvent();
        output.write(event);
        verify(() => mock1.write(event)).called(1);
        verify(() => mock2.write(event)).called(1);
      });

      test('close', () {
        output.close();
        verify(() => mock1.close()).called(1);
        verify(() => mock2.close()).called(1);
      });
    });
  });
}
