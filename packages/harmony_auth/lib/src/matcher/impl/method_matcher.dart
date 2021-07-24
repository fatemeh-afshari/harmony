import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// provide regex or string to match exactly
@internal
class AuthMatcherMethodImpl extends AbstractAuthMatcher {
  final Pattern methodPattern;

  const AuthMatcherMethodImpl(this.methodPattern);

  @override
  bool matches(String method, String _) {
    if (methodPattern is String) {
      return methodPattern == method;
    } else {
      final match = methodPattern.matchAsPrefix(method);
      return match != null && match.end == method.length;
    }
  }
}
