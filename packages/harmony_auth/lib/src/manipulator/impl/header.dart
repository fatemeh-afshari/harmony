import 'package:dio/dio.dart';

import '../manipulator.dart';

class AuthManipulatorHeaderImpl implements AuthManipulator {
  final String key;
  final String Function(String accessToken) value;

  const AuthManipulatorHeaderImpl(this.key, this.value);

  @override
  void manipulate(RequestOptions request, String accessToken) {
    request.headers[key] = value(accessToken);
  }
}
