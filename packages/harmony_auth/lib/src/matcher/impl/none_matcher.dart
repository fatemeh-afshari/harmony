import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// never match
@internal
class AuthMatcherNoneImpl extends AbstractAuthMatcher {
  const AuthMatcherNoneImpl();

  @override
  bool matches(String _, String __) => false;
}
