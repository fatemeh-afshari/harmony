import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// provide regex or string to match exactly
@internal
class AuthMatcherUrlImpl extends AbstractAuthMatcher {
  final Pattern urlPattern;

  const AuthMatcherUrlImpl(this.urlPattern);

  @override
  bool matches(String _, String url) {
    if (urlPattern is String) {
      return urlPattern == url;
    } else {
      final match = urlPattern.matchAsPrefix(url);
      return match != null && match.end == url.length;
    }
  }
}
