import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('LogOutput', () {
    group('custom', () {
      group('init', () {
        test('without', () {
          final output = LogOutput.custom();
          output.init();
        });

        test('with', () {
          var x = false;
          final output = LogOutput.custom(
            init: () => x = true,
          );
          output.init();
          expect(x, isTrue);
        });
      });

      group('write', () {
        test('without', () {
          final output = LogOutput.custom();
          output.write(FakeLogEvent());
        });

        test('with', () {
          final event = FakeLogEvent();
          LogEvent? x;
          final output = LogOutput.custom(
            write: (e) => x = e,
          );
          output.write(event);
          expect(x, equals(event));
        });
      });

      group('close', () {
        test('without', () {
          final output = LogOutput.custom();
          output.close();
        });

        test('with', () {
          var x = false;
          final output = LogOutput.custom(
            close: () => x = true,
          );
          output.close();
          expect(x, isTrue);
        });
      });
    });
  });
}
