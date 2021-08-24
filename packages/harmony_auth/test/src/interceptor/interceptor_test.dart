import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/interceptor/impl/impl.dart';
import 'package:harmony_auth/src/interceptor/interceptor.dart';
import 'package:harmony_auth/src/token/token.dart';
import 'package:mocktail/mocktail.dart';

const keyRetry = 'harmony_auth_is_retry';

const testUrl = 'https://test';

const refreshUrl = 'https://refresh';

final token1 = AuthToken(refresh: 'r1', access: 'a1');

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeResponse extends Fake implements Response<dynamic> {}

class OtherError implements Exception {}

class MockAdapter extends Mock implements HttpClientAdapter {}

void main() {
  group('AuthException', () {
    group('standard', () {
      test('initialization', () {
        final e = AuthExceptionStandardImpl();
        expect(e, isA<AuthException>());
        expect(
          e.toString(),
          stringContainsInOrder(['AuthException', 'standard']),
        );
      });
    });
  });

  group('AuthDioErrorExtensions', () {
    test('isAuthException', () {
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.other,
          error: AuthExceptionStandardImpl(),
        ).isAuthException,
        isTrue,
      );
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.response,
          error: AuthExceptionStandardImpl(),
        ).isAuthException,
        isFalse,
      );
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.other,
          error: AssertionError(),
        ).isAuthException,
        isFalse,
      );
    });
  });
}
