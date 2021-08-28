import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/log/base/default_tag_log.dart';

class ImplTag extends DefaultTagLog {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  group('Log', () {
    group('DefaultTagLog', () {
      test('tag', () {
        final log = ImplTag();
        expect(log.tag, isNull);
      });
    });
  });
}
