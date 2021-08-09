import 'package:meta/meta.dart';

import '../base/base.dart';

/// provide lambda for method
@internal
class AuthMatcherByMethodImpl extends AbstractMethodUrlAuthMatcher {
  final bool Function(String method) matchMethod;

  const AuthMatcherByMethodImpl(this.matchMethod);

  @override
  bool matches(String method, String _) => matchMethod(method);
}
