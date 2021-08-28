import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/base/abstract_log.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

class ImplLog extends AbstractLog {
  final AbstractLog base;

  @override
  final String tag;

  const ImplLog(this.base, this.tag);

  @override
  void init() {}

  @override
  void write(LogEvent event) => base.write(event);

  @override
  void close() {}
}

class MockAbstractLog extends Mock implements AbstractLog {}

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('Log', () {
    group('AbstractLog', () {
      group('log', () {
        late AbstractLog base;
        late Log log;

        setUp(() {
          registerFallbackValue(FakeLogEvent());
          base = MockAbstractLog();
          log = ImplLog(base, 'tag');
        });

        tearDown(() {
          resetMocktailState();
        });

        test('log', () {
          final trace = StackTrace.empty;
          log.log(
            LogLevel.wtf,
            'message',
            error: 'error',
            stackTrace: trace,
            extra: 'extra',
          );
          verify(
            () => base.write(
              any(
                that: predicate(
                  (LogEvent e) =>
                      e.time is DateTime &&
                      Uuid.isValidUUID(fromString: e.id) &&
                      e.stackTrace == trace &&
                      e.extra == 'extra' &&
                      e.error == 'error' &&
                      e.level == LogLevel.wtf &&
                      e.message == 'message',
                ),
              ),
            ),
          ).called(1);
        });
      });
    });
  });
}
