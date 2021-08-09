import 'package:dio/dio.dart';

import '../manipulator.dart';

class AuthManipulatorHeadersImpl implements AuthManipulator {
  final Map<String, String> Function(String accessToken) headers;

  const AuthManipulatorHeadersImpl(this.headers);

  @override
  void manipulate(RequestOptions request, String accessToken) {
    request.headers.addAll(headers(accessToken));
  }
}
