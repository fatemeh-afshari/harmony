import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../token/token.dart';
import '../manipulator.dart';

@internal
class AuthManipulatorHeaderPrefixedImpl implements AuthManipulator {
  final String key;
  final String valuePrefix;

  const AuthManipulatorHeaderPrefixedImpl(this.key, this.valuePrefix);

  @override
  void manipulate(RequestOptions request, AuthToken token) {
    request.headers[key] = '$valuePrefix${token.access}';
  }
}
