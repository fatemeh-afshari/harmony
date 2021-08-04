import 'impl/exception.dart';

/// exceptions of harmony_auth module.
///
/// If [AuthExceptions] happens [DioError] will have
/// [type] of [DioErrorType.other] and [error] of type
/// [AuthException].
///
/// When you get [AuthException], it means that
/// you should reauthenticate the current user.
///
/// [AuthException] is also used in [AuthRest] to
/// indicate refresh errors due to invalid refresh tokens.
class AuthException implements Exception {
  const factory AuthException() = AuthExceptionImpl;
}
