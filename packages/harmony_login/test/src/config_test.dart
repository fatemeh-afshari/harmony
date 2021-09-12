import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_login/src/config.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  group('LoginConfig', () {
    tearDown(() {
      LoginConfig.logger = null;
    });

    test('logger', () {
      expect(LoginConfig.logger, isNull);
      final logger = MockLogger();
      LoginConfig.logger = logger;
      expect(identical(LoginConfig.logger, logger), isTrue);
      LoginConfig.logger = null;
      expect(LoginConfig.logger, isNull);
    });

    group('log', () {
      test('with logger', () {
        final logger = MockLogger();
        when(() => logger.i(any<dynamic>(), any<dynamic>(), any()))
            .thenAnswer((_) {});
        LoginConfig.logger = logger;
        LoginConfig.log('msg');
        verify(() => logger.i('msg')).called(1);
        LoginConfig.logger = null;
      });

      test('without logger', () {
        expect(LoginConfig.logger, isNull);
        LoginConfig.log('msg');
        // nothing should happen
      });
    });
  });
}
