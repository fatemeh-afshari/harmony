import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/id/id.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('LogId', () {
    group('standard', () {
      late LogId logId;

      setUp(() {
        logId = LogId();
      });

      test('generate', () {
        final id1 = logId.generate();
        final id2 = logId.generate();

        expect(id1, isNot(equals(id2)));
        expect(Uuid.isValidUUID(fromString: id1), isTrue);
        expect(Uuid.isValidUUID(fromString: id2), isTrue);
      });
    });
  });
}
