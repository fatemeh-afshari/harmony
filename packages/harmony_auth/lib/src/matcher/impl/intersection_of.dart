import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../base/base.dart';
import '../matcher.dart';

@internal
class AuthMatcherIntersectionOfImpl extends AbstractAuthMatcher {
  final List<AuthMatcher> matchers;

  const AuthMatcherIntersectionOfImpl(this.matchers);

  @override
  bool matchesRequest(RequestOptions request) {
    for (final matcher in matchers) {
      if (!matcher.matchesRequest(request)) {
        return false;
      }
    }
    return true;
  }
}
