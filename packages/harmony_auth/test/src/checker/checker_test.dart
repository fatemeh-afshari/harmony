import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_auth/src/checker/checker.dart';

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeObject extends Fake {}

void main() {
  group('AuthChecker', () {
    group('standard', () {
      test('isUnauthorizedError', () {
        final checker = AuthChecker.standard();
        expect(
          checker.isUnauthorizedError(DioError(
            requestOptions: FakeRequestOptions(),
            response: Response<dynamic>(
              requestOptions: FakeRequestOptions(),
              statusCode: 401,
            ),
            type: DioErrorType.response,
            error: FakeObject(),
          )),
          isTrue,
        );
        expect(
          checker.isUnauthorizedError(DioError(
            requestOptions: FakeRequestOptions(),
            response: Response<dynamic>(
              requestOptions: FakeRequestOptions(),
              statusCode: 401,
            ),
            type: DioErrorType.other,
            error: FakeObject(),
          )),
          isFalse,
        );
        expect(
          checker.isUnauthorizedError(DioError(
            requestOptions: FakeRequestOptions(),
            response: Response<dynamic>(
              requestOptions: FakeRequestOptions(),
              statusCode: 404,
            ),
            type: DioErrorType.response,
            error: FakeObject(),
          )),
          isFalse,
        );
      });
    });
  });
}
