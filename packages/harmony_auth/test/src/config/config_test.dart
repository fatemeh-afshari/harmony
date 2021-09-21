import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/config/config.dart';
import 'package:harmony_log/harmony_log.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements Log {}

void main() {
  group('AuthConfig', () {
    tearDown(() {
      AuthConfig.log = null;
    });

    test('logger', () {
      expect(AuthConfig.log, isNull);
      final logger = MockLogger();
      when(() => logger.tagged('harmony_auth')).thenReturn(logger);
      AuthConfig.log = logger;
      expect(identical(AuthConfig.log, logger), isTrue);
      AuthConfig.log = null;
      expect(AuthConfig.log, isNull);
    });

    group('log', () {
      test('with logger', () {
        final logger = MockLogger();
        when(() => logger.tagged('harmony_auth')).thenReturn(logger);
        AuthConfig.log = logger;
        AuthConfig.logI('msg');
        verify(() => logger.log(LogLevel.info, 'msg')).called(1);
        AuthConfig.log = null;
      });

      test('without logger', () {
        expect(AuthConfig.log, isNull);
        AuthConfig.logI('msg');
        // nothing should happen
      });
    });
  });
}
