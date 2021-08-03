import 'package:meta/meta.dart';

import '../base/abstract_matcher.dart';

/// always match
@internal
class AuthMatcherAllImpl extends AbstractAuthMatcher {
  const AuthMatcherAllImpl();

  @override
  bool matches(String _, String __) => true;
}
