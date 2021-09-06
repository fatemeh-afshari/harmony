import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/id/id.dart';

void main() {
  group('LogId', () {
    group('by', () {
      late LogId logId;

      setUp(() {
        logId = LogId.by(() => 'hello');
      });

      test('generate', () {
        final id1 = logId.generate();
        final id2 = logId.generate();

        expect(id1, equals('hello'));
        expect(id2, equals('hello'));
      });
    });
  });
}
