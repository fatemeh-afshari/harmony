import 'package:meta/meta.dart';

import '../base/base.dart';

/// provide lambda for url and method
@internal
class AuthMatcherMethodAndUrlImpl extends AbstractMethodUrlAuthMatcher {
  final Pattern methodPattern;
  final Pattern urlPattern;

  const AuthMatcherMethodAndUrlImpl(this.methodPattern, this.urlPattern);

  @override
  bool matches(String method, String url) {
    if (methodPattern is String) {
      if (methodPattern != method) return false;
    } else {
      final match = methodPattern.matchAsPrefix(method);
      if (match == null || match.end != method.length) return false;
    }
    if (urlPattern is String) {
      if (urlPattern != url) return false;
    } else {
      final match = urlPattern.matchAsPrefix(url);
      if (match == null || match.end != url.length) return false;
    }
    return true;
  }
}
