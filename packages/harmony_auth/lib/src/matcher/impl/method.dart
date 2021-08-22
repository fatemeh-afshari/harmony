import 'package:meta/meta.dart';

import '../base/base.dart';


@internal
class AuthMatcherMethodImpl extends AbstractMethodUrlAuthMatcher {
  final Pattern methodPattern;

  const AuthMatcherMethodImpl(this.methodPattern);

  @override
  bool matches(String method, String _) {
    if (methodPattern is String) {
      return methodPattern == method;
    } else {
      final match = methodPattern.matchAsPrefix(method);
      return match != null && match.end == method.length;
    }
  }
}
