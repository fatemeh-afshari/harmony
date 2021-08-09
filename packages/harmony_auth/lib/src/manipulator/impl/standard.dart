import 'package:meta/meta.dart';

import 'impl.dart';

@internal
class AuthManipulatorStandardImpl extends AuthManipulatorHeaderPrefixedImpl {
  const AuthManipulatorStandardImpl() : super('authorization', 'Bearer ');
}
