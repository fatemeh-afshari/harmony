import 'package:meta/meta.dart';

import '../rest.dart';

@internal
class AuthRestExceptionExternalImpl implements AuthRestException {
  const AuthRestExceptionExternalImpl();

  @override
  String toString() => 'AuthRestException';
}
