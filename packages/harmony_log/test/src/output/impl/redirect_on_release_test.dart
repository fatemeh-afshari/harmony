import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:mocktail/mocktail.dart';

class FakeLogEvent extends Fake implements LogEvent {}

class MockLogOutput extends Mock implements LogOutput {}

void main() {
  group('LogOutput', () {
    group('redirect', () {
      late LogOutput child;
      late LogOutput output;

      setUp(() {
        registerFallbackValue(FakeLogEvent());
        child = MockLogOutput();
        output = LogOutput.redirectOnRelease(
          child: child,
        );
      });

      tearDown(() {
        verifyNoMoreInteractions(child);
        resetMocktailState();
      });

      test('init', () {
        output.init();
        if (kReleaseMode) {
          verify(() => child.init()).called(1);
        } else {
          verifyNever(() => child.init());
        }
      });

      test('write', () {
        final event = FakeLogEvent();
        output.write(event);
        if (kReleaseMode) {
          verify(() => child.write(event)).called(1);
        } else {
          verifyNever(() => child.write(any()));
        }
      });

      test('close', () {
        output.close();
        if (kReleaseMode) {
          verify(() => child.close()).called(1);
        } else {
          verifyNever(() => child.close());
        }
      });
    });
  });
}
