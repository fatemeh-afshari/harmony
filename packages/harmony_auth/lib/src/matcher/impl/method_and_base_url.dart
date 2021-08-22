import 'package:meta/meta.dart';

import '../base/base.dart';

@internal
class AuthMatcherMethodAndBaseUrlImpl extends AbstractMethodUrlAuthMatcher {
  final Pattern methodPattern;
  final String baseUrl;

  const AuthMatcherMethodAndBaseUrlImpl(this.methodPattern, this.baseUrl);

  @override
  bool matches(String method, String url) {
    if (methodPattern is String) {
      if (methodPattern != method) return false;
    } else {
      final match = methodPattern.matchAsPrefix(method);
      if (match == null || match.end != method.length) return false;
    }
    return url.startsWith(baseUrl);
  }
}
