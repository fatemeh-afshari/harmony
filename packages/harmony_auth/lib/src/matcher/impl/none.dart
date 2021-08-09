import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../base/base.dart';

/// never match
@internal
class AuthMatcherNoneImpl extends AbstractAuthMatcher {
  const AuthMatcherNoneImpl();

  @override
  bool matchesRequest(RequestOptions _) => false;
}
