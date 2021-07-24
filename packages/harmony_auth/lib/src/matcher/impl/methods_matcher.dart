import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// provide regex or string to match exactly
///
/// should not be empty
@internal
class AuthMatcherMethodsImpl extends AbstractAuthMatcher {
  /// should not be empty
  final Set<Pattern> methodPatterns;

  AuthMatcherMethodsImpl(this.methodPatterns) {
    if (methodPatterns.isEmpty) throw AssertionError();
  }

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
