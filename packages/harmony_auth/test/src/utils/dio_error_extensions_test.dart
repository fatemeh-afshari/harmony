import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/exception/exception.dart';
import 'package:harmony_auth/src/utils/dio_error_extensions.dart';

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
  });
}
