import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/plain/output/output.dart';
import 'package:mocktail/mocktail.dart';

class MockLogPlainOutput extends Mock implements LogPlainOutput {}

void main() {
  group('LogPlainOutput', () {
    group('multi', () {
      group('empty', () {
        late LogPlainOutput output;

        setUp(() {
          output = LogPlainOutput.multi(children: []);
        });

        test('init', () {
          output.init();
        });

        test('write', () {
          output.write(['abc', 'def']);
        });

        test('close', () {
          output.close();
        });
      });

      group('with two', () {
        late LogPlainOutput child1;
        late LogPlainOutput child2;
        late LogPlainOutput output;

        setUp(() {
          child1 = MockLogPlainOutput();
          child2 = MockLogPlainOutput();
          output = LogPlainOutput.multi(children: [child1, child2]);
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
          final event = ['abc', 'def'];
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
