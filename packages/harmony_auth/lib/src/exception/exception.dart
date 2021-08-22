import 'impl/exception.dart';

/// exceptions of harmony_auth module.
///
/// If [AuthExceptions] happens [DioError] will have
/// [type] of [DioErrorType.other] and [error] of type
/// [AuthException].
///
/// You can use [isAuthException] extension function on
/// [DioError] to check if error is from auth exception.
///
/// When you get [AuthException], it means that
/// you should reauthenticate the current user and
/// no token is available.
///
/// [AuthException] is also used in [AuthRest] and [AuthRepository]
/// to indicate refresh errors due to invalid refresh tokens.
class AuthException implements Exception {
  const factory AuthException() = AuthExceptionImpl;
}
