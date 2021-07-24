import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// base url matching
///
/// should end with '/'
@internal
class AuthMatcherBaseUrlImpl extends AbstractAuthMatcher {
  /// should end with '/'
  final String baseUrl;

  AuthMatcherBaseUrlImpl(this.baseUrl) {
    if (!baseUrl.endsWith('/')) throw AssertionError();
  }

  @override
  bool matches(String _, String url) {
    final base = baseUrl.substring(0, baseUrl.length - 1);
    return url.startsWith(base);
  }
}
