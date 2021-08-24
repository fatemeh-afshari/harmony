import 'package:meta/meta.dart';

import '../base/base.dart';

@internal
class AuthMatcherUrlsImpl extends AbstractMethodUrlAuthMatcher {
  final Set<Pattern> urlPatterns;

  const AuthMatcherUrlsImpl(this.urlPatterns);

  @override
  bool matches(String _, String url) {
    for (final pattern in urlPatterns) {
      if (pattern is String) {
        if (pattern == url) return true;
      } else {
        final match = pattern.matchAsPrefix(url);
        if (match != null && match.end == url.length) return true;
      }
    }
    return false;
  }
}
