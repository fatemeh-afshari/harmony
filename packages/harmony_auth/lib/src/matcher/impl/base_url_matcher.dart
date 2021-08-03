import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// base url matching
@internal
class AuthMatcherBaseUrlImpl extends AbstractAuthMatcher {
  final String baseUrl;

  const AuthMatcherBaseUrlImpl(this.baseUrl);

  @override
  bool matches(String _, String url) {
    return url.startsWith(baseUrl);
  }
}
