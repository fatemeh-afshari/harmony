import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/id/id.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:mocktail/mocktail.dart';

class MockLogOutput extends Mock implements LogOutput {}

class FakeLogEvent extends Fake implements LogEvent {}

void main() {
  group('Log', () {
    group('standard', () {
      group('with tag', () {
        late LogOutput output;
        late Log log;

        setUp(() {
          registerFallbackValue(FakeLogEvent());
          output = MockLogOutput();
          log = Log(
            tag: 'TAG',
            id: LogId.constant('hello'),
            child: output,
          );
        });

        tearDown(() {
          verifyNoMoreInteractions(output);
          resetMocktailState();
        });

        test('tag', () {
          expect(log.tag, equals('TAG'));
        });

        test('init', () {
          log.init();
          verify(() => output.init()).called(1);
        });

        test('write', () {
          final event = FakeLogEvent();
          log.write(event);
          verify(() => output.write(event)).called(1);
        });

        test('close', () {
          log.close();
          verify(() => output.close()).called(1);
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
            () => output.write(
              any(
                that: predicate(
                  (LogEvent e) =>
                      e.tag == 'TAG' &&
                      e.id == 'hello' &&
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

        group('tagged', () {
          test('log', () {
            final trace = StackTrace.empty;
            log.tagged('OTHER').log(
                  LogLevel.wtf,
                  'message',
                  error: 'error',
                  stackTrace: trace,
                  extra: 'extra',
                );
            verify(
              () => output.write(
                any(
                  that: predicate(
                    (LogEvent e) =>
                        e.tag == 'OTHER' &&
                        e.id == 'hello' &&
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

      group('without tag', () {
        late LogOutput output;
        late Log log;

        setUp(() {
          registerFallbackValue(FakeLogEvent());
          output = MockLogOutput();
          log = Log(
            tag: null,
            id: LogId.constant('hello'),
            child: output,
          );
        });

        tearDown(() {
          verifyNoMoreInteractions(output);
          resetMocktailState();
        });

        test('tag', () {
          expect(log.tag, isNull);
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
            () => output.write(
              any(
                that: predicate(
                  (LogEvent e) =>
                      e.tag == null &&
                      e.id == 'hello' &&
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
