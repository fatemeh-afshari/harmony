import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

/// extension methods to check if [DioError] was
/// of the form unauthorized (401)
@internal
extension AuthDioErrorIntermediateExtensions on DioError {
  bool get isUnauthorized =>
      type == DioErrorType.response && response?.statusCode == 401;
}
