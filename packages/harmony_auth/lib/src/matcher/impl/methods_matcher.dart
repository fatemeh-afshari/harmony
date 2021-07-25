import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// provide regex or string to match exactly
@internal
class AuthMatcherMethodsImpl extends AbstractAuthMatcher {
  final Set<Pattern> methodPatterns;

  const AuthMatcherMethodsImpl(this.methodPatterns);

  @override
  bool matches(String method, String _) {
    for (final pattern in methodPatterns) {
      if (pattern is String) {
        if (pattern == method) return true;
      } else {
        final match = pattern.matchAsPrefix(method);
        if (match != null && match.end == method.length) return true;
      }
    }
    return false;
  }
}
