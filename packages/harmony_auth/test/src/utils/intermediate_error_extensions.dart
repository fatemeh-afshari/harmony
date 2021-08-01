import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/utils/intermediate_error_extensions.dart';

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeObject extends Fake {}

void main() {
  group('IntermediateErrorExtensions', () {
    test('isUnauthorized', () {
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: Response<dynamic>(
            requestOptions: FakeRequestOptions(),
            statusCode: 401,
          ),
          type: DioErrorType.response,
          error: FakeObject(),
        ).isUnauthorized,
        isTrue,
      );
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: Response<dynamic>(
            requestOptions: FakeRequestOptions(),
            statusCode: 401,
          ),
          type: DioErrorType.other,
          error: FakeObject(),
        ).isUnauthorized,
        isFalse,
      );
      expect(
        DioError(
          requestOptions: FakeRequestOptions(),
          response: Response<dynamic>(
            requestOptions: FakeRequestOptions(),
            statusCode: 404,
          ),
          type: DioErrorType.response,
          error: FakeObject(),
        ).isUnauthorized,
        isFalse,
      );
    });
  });
}
