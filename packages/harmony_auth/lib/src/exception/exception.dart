import 'impl/exception.dart';

abstract class AuthException implements Exception {
  String get code;

  const factory AuthException(String code) = AuthExceptionImpl;
}
