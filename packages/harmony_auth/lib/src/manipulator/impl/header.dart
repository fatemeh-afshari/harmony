import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../manipulator.dart';

@internal
class AuthManipulatorHeaderImpl implements AuthManipulator {
  final String key;
  final String Function(String accessToken) value;

  const AuthManipulatorHeaderImpl(this.key, this.value);

  @override
  void manipulate(RequestOptions request, String accessToken) {
    request.headers[key] = value(accessToken);
  }
}
