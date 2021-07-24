import 'package:meta/meta.dart';

import '../exception.dart';

@internal
@immutable
class AuthExceptionImpl implements AuthException {
  @override
  final String code;

  const AuthExceptionImpl(this.code);

  @override
  String toString() => 'AuthException{$code}';
}
