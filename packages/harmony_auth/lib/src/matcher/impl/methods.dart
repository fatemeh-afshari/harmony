import 'package:meta/meta.dart';

import '../base/base.dart';


@internal
class AuthMatcherMethodsImpl extends AbstractMethodUrlAuthMatcher {
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
