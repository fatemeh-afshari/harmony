import 'impl/exception.dart';

/// exceptions of harmony_auth module.
///
/// it will be inside [DioError.error] field.
///
/// When you get [AuthException] error, it means that
/// you should reauthenticate the current user.
abstract class AuthException implements Exception {
  /// code for further analysis of error
  String get code;

  const factory AuthException(String code) = AuthExceptionImpl;
}
