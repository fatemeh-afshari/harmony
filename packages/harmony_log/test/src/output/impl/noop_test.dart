import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:mocktail/mocktail.dart';

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('LogOutput', () {
    group('noop', () {
      late LogOutput output;

      setUp(() {
        output = LogOutput.noop();
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
  });
}
