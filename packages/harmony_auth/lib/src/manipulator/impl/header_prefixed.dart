import 'package:dio/dio.dart';

import '../manipulator.dart';

class AuthManipulatorHeaderPrefixedImpl implements AuthManipulator {
  final String key;
  final String valuePrefix;

  const AuthManipulatorHeaderPrefixedImpl(this.key, this.valuePrefix);

  @override
  void manipulate(RequestOptions request, String accessToken) {
    request.headers[key] = '$valuePrefix$accessToken';
  }
}
