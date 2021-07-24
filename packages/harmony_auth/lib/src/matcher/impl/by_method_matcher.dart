import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// provide lambda for method
@internal
class AuthMatcherByMethodImpl extends AbstractAuthMatcher {
  final bool Function(String method) matchMethod;

  const AuthMatcherByMethodImpl(this.matchMethod);

  @override
  bool matches(String method, String _) => matchMethod(method);
}
