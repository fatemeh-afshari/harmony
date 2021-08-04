import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// provide lambda for url
@internal
class AuthMatcherByMethodAndUrlImpl extends AbstractAuthMatcher {
  final bool Function(String method, String url) match;

  const AuthMatcherByMethodAndUrlImpl(this.match);

  @override
  bool matches(String method, String url) => match(method, url);
}
