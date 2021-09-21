import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/config/config.dart';
import 'package:harmony_log/harmony_log.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements Log {}

void main() {
  group('AuthConfig', () {
    tearDown(() {
      AuthConfig.logger = null;
    });

    test('logger', () {
      expect(AuthConfig.logger, isNull);
      final logger = MockLogger();
      AuthConfig.logger = logger;
      expect(identical(AuthConfig.logger, logger), isTrue);
      AuthConfig.logger = null;
      expect(AuthConfig.logger, isNull);
    });

    group('log', () {
      test('with logger', () {
        final logger = MockLogger();
        AuthConfig.logger = logger;
        AuthConfig.log('msg');
        verify(() => logger.log(LogLevel.info, 'msg')).called(1);
        AuthConfig.logger = null;
      });

      test('without logger', () {
        expect(AuthConfig.logger, isNull);
        AuthConfig.log('msg');
        // nothing should happen
      });
    });
  });
}
