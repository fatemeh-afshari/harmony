import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../base/base.dart';
import '../matcher.dart';

@internal
class AuthMatcherUnionOfImpl extends AbstractAuthMatcher {
  final List<AuthMatcher> matchers;

  const AuthMatcherUnionOfImpl(this.matchers);

  @override
  bool matchesRequest(RequestOptions request) {
    for (final matcher in matchers) {
      if (matcher.matchesRequest(request)) {
        return true;
      }
    }
    return false;
  }
}
