import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// base url matching
///
/// should end with '/'
///
/// should not be empty
@internal
class AuthMatcherBaseUrlsImpl extends AbstractAuthMatcher {
  /// should end with '/'
  ///
  /// should not be empty
  final Set<String> baseUrls;

  AuthMatcherBaseUrlsImpl(this.baseUrls) {
    if (baseUrls.isEmpty) throw AssertionError();
    for (final baseUrl in baseUrls) {
      if (!baseUrl.endsWith('/')) throw AssertionError();
    }
  }

  @override
  bool matches(String _, String url) {
    for (final baseUrl in baseUrls) {
      final base = baseUrl.substring(0, baseUrl.length - 1);
      if (url.startsWith(base)) return true;
    }
    return false;
  }
}
