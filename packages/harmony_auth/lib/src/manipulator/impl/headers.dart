import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../token/token.dart';
import '../manipulator.dart';

@internal
class AuthManipulatorHeadersImpl implements AuthManipulator {
  final Map<String, String> Function(AuthToken token) headers;

  const AuthManipulatorHeadersImpl(this.headers);

  @override
  void manipulate(RequestOptions request, AuthToken token) {
    request.headers.addAll(headers(token));
  }
}
