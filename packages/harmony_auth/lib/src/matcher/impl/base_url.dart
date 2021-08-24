import 'package:meta/meta.dart';

import '../base/base.dart';

@internal
class AuthMatcherBaseUrlImpl extends AbstractMethodUrlAuthMatcher {
  final String baseUrl;

  const AuthMatcherBaseUrlImpl(this.baseUrl);

  @override
  bool matches(String _, String url) {
    return url.startsWith(baseUrl);
  }
}
