import 'impl.dart';

class AuthManipulatorStandardImpl extends AuthManipulatorHeaderPrefixedImpl {
  const AuthManipulatorStandardImpl() : super('authorization', 'Bearer ');
}
