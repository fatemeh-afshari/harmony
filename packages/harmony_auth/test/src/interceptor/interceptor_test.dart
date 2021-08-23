import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/interceptor/impl/impl.dart';
import 'package:harmony_auth/src/interceptor/interceptor.dart';
import 'package:mocktail/mocktail.dart';

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeResponse extends Fake implements Response<dynamic> {}

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
