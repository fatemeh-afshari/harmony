import 'package:meta/meta.dart';

import '../base/base.dart';

/// provide lambda for url and method
@internal
class AuthMatcherByMethodAndUrlImpl extends AbstractMethodUrlAuthMatcher {
  final bool Function(String method, String url) match;

  const AuthMatcherByMethodAndUrlImpl(this.match);

  @override
  bool matches(String method, String url) => match(method, url);
}
