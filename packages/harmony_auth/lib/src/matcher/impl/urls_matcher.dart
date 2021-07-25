import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// provide regex or string to match exactly
@internal
class AuthMatcherUrlsImpl extends AbstractAuthMatcher {
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
