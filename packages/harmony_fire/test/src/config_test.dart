import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_fire/src/config/config.dart';
import 'package:harmony_log/harmony_log.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements Log {}

void main() {
  group('FireConfig', () {
    tearDown(() {
      FireConfig.log = null;
    });

    test('logger', () {
      expect(FireConfig.log, isNull);
      final logger = MockLogger();
      when(() => logger.tagged('harmony_fire')).thenReturn(logger);
      FireConfig.log = logger;
      expect(identical(FireConfig.log, logger), isTrue);
      FireConfig.log = null;
      expect(FireConfig.log, isNull);
    });

    group('log', () {
      test('with logger', () {
        final logger = MockLogger();
        when(() => logger.tagged('harmony_fire')).thenReturn(logger);
        FireConfig.log = logger;
        FireConfig.logI('msg');
        verify(() => logger.log(LogLevel.info, 'msg')).called(1);
        FireConfig.log = null;
      });

      test('without logger', () {
        expect(FireConfig.log, isNull);
        FireConfig.logI('msg');
        // nothing should happen
      });
    });
  });
}
