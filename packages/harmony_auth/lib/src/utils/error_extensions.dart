import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

///extensions to transform an [Object] to [DioError].
@internal
extension AuthErrorExt on Object {
  /// transform an [Object] to [DioError].
  @internal
  DioError toDioError(RequestOptions request) => DioError(
        requestOptions: request,
        type: DioErrorType.other,
        response: null,
        error: this,
      );
}
