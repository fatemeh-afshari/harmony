import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/plain/output/output.dart';
import 'package:mocktail/mocktail.dart';

class MockLogPlainOutput extends Mock implements LogPlainOutput {}

void main() {
  group('LogPlainOutput', () {
    group('redirect', () {
      group('enabled', () {
        late LogPlainOutput child;
        late LogPlainOutput output;

        setUp(() {
          registerFallbackValue(<String>[]);
          child = MockLogPlainOutput();
          output = LogPlainOutput.redirect(
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

        test('write', () {
          final event = ['abc', 'def'];
          output.write(event);
          verify(() => child.write(event)).called(1);
        });

        test('close', () {
          output.close();
          verify(() => child.close()).called(1);
        });
      });

      group('not enabled', () {
        late LogPlainOutput child;
        late LogPlainOutput output;

        setUp(() {
          child = MockLogPlainOutput();
          output = LogPlainOutput.redirect(
            enabled: false,
            child: child,
          );
        });

        tearDown(() {
          verifyNoMoreInteractions(child);
          resetMocktailState();
        });

        test('init', () {
          output.init();
          verifyNever(() => child.init());
        });

        test('write', () {
          output.write(['abc', 'def']);
          verifyNever(() => child.write(any()));
        });

        test('close', () {
          output.close();
          verifyNever(() => child.close());
        });
      });
    });
  });
}
