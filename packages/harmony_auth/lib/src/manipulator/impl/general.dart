import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../token/token.dart';
import '../manipulator.dart';

@internal
class AuthManipulatorGeneralImpl implements AuthManipulator {
  final void Function(RequestOptions request, AuthToken token) lambda;

  const AuthManipulatorGeneralImpl(this.lambda);

  @override
  void manipulate(RequestOptions request, AuthToken token) {
    lambda(request, token);
  }
}
