import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// base urls matching
@internal
class AuthMatcherBaseUrlsImpl extends AbstractAuthMatcher {
  final Set<String> baseUrls;

  const AuthMatcherBaseUrlsImpl(this.baseUrls);

  @override
  bool matches(String _, String url) {
    for (final baseUrl in baseUrls) {
      if (url.startsWith(baseUrl)) return true;
    }
    return false;
  }
}
