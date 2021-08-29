import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/plain/format/format.dart';
import 'package:mocktail/mocktail.dart';

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('LogPlainFormat', () {
    group('custom', () {
      test('format', () {
        final e = FakeLogEvent();
        final list = ['abc','def'];
        dynamic x;
        final format = LogPlainFormat.custom((event) {
           x = event;
           return list;
        });
        expect(format.format(e), equals(list));
        expect(x, equals(e));
      });
    });
  });
}
