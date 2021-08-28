import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:mocktail/mocktail.dart';

class FakeLogEvent extends Fake implements LogEvent {}

class MockLogOutput extends Mock implements LogOutput {}

void main() {
  group('LogOutput', () {
    group('multi', () {
      group('empty', () {
        late LogOutput output;

        setUp(() {
          output = LogOutput.multi([]);
        });

        test('init', () {
          output.init();
        });

        test('write', () {
          output.write(FakeLogEvent());
        });

        test('close', () {
          output.close();
        });
      });

      group('with two', () {
        late LogOutput child1;
        late LogOutput child2;
        late LogOutput output;

        setUp(() {
          child1 = MockLogOutput();
          child2 = MockLogOutput();
          output = LogOutput.multi([child1, child2]);
        });

        tearDown(() {
          verifyNoMoreInteractions(child1);
          verifyNoMoreInteractions(child2);
          resetMocktailState();
        });

        test('init', () {
          output.init();
          verify(() => child1.init()).called(1);
          verify(() => child2.init()).called(1);
        });

        test('write', () {
          final event = FakeLogEvent();
          output.write(event);
          verify(() => child1.write(event)).called(1);
          verify(() => child2.write(event)).called(1);
        });

        test('close', () {
          output.close();
          verify(() => child1.close()).called(1);
          verify(() => child2.close()).called(1);
        });
      });
    });
  });
}
