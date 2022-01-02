import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/plain/output/output.dart';

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('LogPlainOutput', () {
    group('custom', () {
      group('init', () {
        test('without', () {
          final output = LogPlainOutput.custom();
          output.init();
        });

        test('with', () {
          var x = false;
          final output = LogPlainOutput.custom(
            init: () => x = true,
          );
          output.init();
          expect(x, isTrue);
        });
      });

      group('write', () {
        test('without', () {
          final output = LogPlainOutput.custom();
          output.write(['abc', 'def']);
        });

        test('with', () {
          final event = ['abc', 'def'];
          Iterable<String>? x;
          final output = LogPlainOutput.custom(
            write: (e) => x = e,
          );
          output.write(event);
          expect(x, equals(event));
        });
      });

      group('close', () {
        test('without', () {
          final output = LogPlainOutput.custom();
          output.close();
        });

        test('with', () {
          var x = false;
          final output = LogPlainOutput.custom(
            close: () => x = true,
          );
          output.close();
          expect(x, isTrue);
        });
      });
    });
  });
}
