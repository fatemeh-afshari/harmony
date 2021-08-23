import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../base/base.dart';

@internal
class AuthMatcherAllImpl extends AbstractAuthMatcher {
  const AuthMatcherAllImpl();

  @override
  bool matchesRequest(RequestOptions _) => true;
}
