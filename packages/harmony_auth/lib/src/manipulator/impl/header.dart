import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../token/token.dart';
import '../manipulator.dart';


@internal
class AuthManipulatorHeaderImpl implements AuthManipulator {
  final String key;
  final String Function(AuthToken token) value;

  const AuthManipulatorHeaderImpl(this.key, this.value);

  @override
  void manipulate(RequestOptions request, AuthToken token) {
    request.headers[key] = value(token);
  }
}
