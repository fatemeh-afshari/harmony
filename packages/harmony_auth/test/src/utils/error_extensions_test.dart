import 'package:dio/dio.dart';
import 'package:harmony_auth/src/exception/exception.dart';
import 'package:harmony_auth/src/utils/error_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeResponse extends Fake implements Response<dynamic> {}

void main() {
  group('AuthDioErrorExtensions', () {
    test('isAuthException', () {
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.other,
          error: AuthException(),
        ).isAuthException,
        isTrue,
      );
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.response,
          error: AuthException(),
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

    test('asAuthExceptionOrNull', () {
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.other,
          error: AuthException(),
        ).asAuthExceptionOrNull,
        isNotNull,
      );
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.response,
          error: AuthException(),
        ).asAuthExceptionOrNull,
        isNull,
      );
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.other,
          error: AssertionError(),
        ).asAuthExceptionOrNull,
        isNull,
      );
    });

    test('asAuthException', () {
      expect(
        () => DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.other,
          error: AuthException(),
        ).asAuthException,
        isNotNull,
      );
      expect(
        () => DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.response,
          error: AuthException(),
        ).asAuthException,
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => DioError(
          requestOptions: FakeRequestOptions(),
          response: FakeResponse(),
          type: DioErrorType.other,
          error: AssertionError(),
        ).asAuthException,
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
