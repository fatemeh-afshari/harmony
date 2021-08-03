import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// provide lambda for url
@internal
class AuthMatcherByUrlImpl extends AbstractAuthMatcher {
  final bool Function(String url) matchUrl;

  const AuthMatcherByUrlImpl(this.matchUrl);

  @override
  bool matches(String _, String url) => matchUrl(url);
}
