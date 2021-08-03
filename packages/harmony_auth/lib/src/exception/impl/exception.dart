import 'package:meta/meta.dart';

import '../exception.dart';

@immutable
@internal
class AuthExceptionImpl implements AuthException {
  const AuthExceptionImpl();

  @override
  String toString() => 'AuthException';
}
