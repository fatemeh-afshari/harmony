import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/plain/output/output.dart';

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('LogPlainOutput', () {
    group('noop', () {
      late LogPlainOutput output;

      setUp(() {
        output = LogPlainOutput.noop();
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
  });
}
