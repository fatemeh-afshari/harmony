import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_fire/src/config/config.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  group('FireConfig', () {
    tearDown(() {
      FireConfig.logger = null;
    });

    test('logger', () {
      expect(FireConfig.logger, isNull);
      final logger = MockLogger();
      FireConfig.logger = logger;
      expect(identical(FireConfig.logger, logger), isTrue);
      FireConfig.logger = null;
      expect(FireConfig.logger, isNull);
    });

    group('log', () {
      test('with logger', () {
        final logger = MockLogger();
        when(() => logger.i(any<dynamic>(), any<dynamic>(), any()))
            .thenAnswer((_) {});
        FireConfig.logger = logger;
        FireConfig.log('msg');
        verify(() => logger.i('msg')).called(1);
        FireConfig.logger = null;
      });

      test('without logger', () {
        expect(FireConfig.logger, isNull);
        FireConfig.log('msg');
        // nothing should happen
      });
    });
  });
}
