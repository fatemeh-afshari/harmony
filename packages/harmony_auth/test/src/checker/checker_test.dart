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
        expect(
          checker.isUnauthorizedError(DioError(
            requestOptions: FakeRequestOptions(),
            response: Response<dynamic>(
              requestOptions: FakeRequestOptions(),
              statusCode: null,
            ),
            type: DioErrorType.response,
            error: FakeObject(),
          )),
          isFalse,
        );
      });
    });

    group('statusCode', () {
      test('isUnauthorizedError', () {
        final checker = AuthChecker.statusCode(10);
        expect(
          checker.isUnauthorizedError(DioError(
            requestOptions: FakeRequestOptions(),
            response: Response<dynamic>(
              requestOptions: FakeRequestOptions(),
              statusCode: 10,
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
              statusCode: 20,
            ),
            type: DioErrorType.response,
            error: FakeObject(),
          )),
          isFalse,
        );
      });
    });

    group('statusCodes', () {
      test('isUnauthorizedError', () {
        final checker = AuthChecker.statusCodes({10, 20});
        expect(
          checker.isUnauthorizedError(DioError(
            requestOptions: FakeRequestOptions(),
            response: Response<dynamic>(
              requestOptions: FakeRequestOptions(),
              statusCode: 10,
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
              statusCode: 20,
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
              statusCode: 30,
            ),
            type: DioErrorType.response,
            error: FakeObject(),
          )),
          isFalse,
        );
      });
    });

    group('byStatusCode', () {
      test('isUnauthorizedError', () {
        final checker = AuthChecker.byStatusCode(
          (s) => s == 10,
        );
        expect(
          checker.isUnauthorizedError(DioError(
            requestOptions: FakeRequestOptions(),
            response: Response<dynamic>(
              requestOptions: FakeRequestOptions(),
              statusCode: 10,
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
              statusCode: 20,
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
