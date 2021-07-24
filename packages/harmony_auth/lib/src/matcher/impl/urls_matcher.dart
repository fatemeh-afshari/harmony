import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// provide regex or string to match exactly
///
/// should not be empty
@internal
class AuthMatcherUrlsImpl extends AbstractAuthMatcher {
  /// should not be empty
  final Set<Pattern> urlPatterns;

  AuthMatcherUrlsImpl(this.urlPatterns) {
    if (urlPatterns.isEmpty) throw AssertionError();
  }

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
