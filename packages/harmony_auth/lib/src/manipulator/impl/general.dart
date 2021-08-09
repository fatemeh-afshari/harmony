import 'package:dio/dio.dart';

import '../manipulator.dart';

class AuthManipulatorGeneralImpl implements AuthManipulator {
  final void Function(RequestOptions request, String accessToken) lambda;

  const AuthManipulatorGeneralImpl(this.lambda);

  @override
  void manipulate(RequestOptions request, String accessToken) {
    lambda(request, accessToken);
  }
}
