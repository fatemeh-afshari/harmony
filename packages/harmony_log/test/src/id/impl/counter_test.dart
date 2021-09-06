import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/id/id.dart';

void main() {
  group('LogId', () {
    group('counter', () {
      late LogId logId;

      setUp(() {
        logId = LogId.counter(start: 100);
      });

      test('generate', () {
        final id1 = logId.generate();
        final id2 = logId.generate();

        expect(id1, equals('id-100'));
        expect(id2, equals('id-101'));
      });
    });
  });
}
