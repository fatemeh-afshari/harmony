import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/auth.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  group('Auth', () {
    tearDown(() {
      Auth.logger = null;
    });

    test('field logger', () {
      expect(Auth.logger, isNull);
      final logger = MockLogger();
      Auth.logger = logger;
      expect(identical(Auth.logger, logger), isTrue);
      Auth.logger = null;
      expect(Auth.logger, isNull);
    });

    group('method log', () {
      test('with logger', () {
        final logger = MockLogger();
        when(() => logger.i(any<dynamic>(), any<dynamic>(), any()))
            .thenAnswer((_) {});
        Auth.logger = logger;
        Auth.log('msg');
        verify(() => logger.i('msg')).called(1);
        Auth.logger = null;
      });

      test('without logger', () {
        expect(Auth.logger, isNull);
        Auth.log('msg');
        // nothing should happen
      });
    });
  });
}
