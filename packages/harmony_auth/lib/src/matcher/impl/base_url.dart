import 'package:meta/meta.dart';

import '../base/base.dart';

/// base url matching
@internal
class AuthMatcherBaseUrlImpl extends AbstractMethodUrlAuthMatcher {
  final String baseUrl;

  const AuthMatcherBaseUrlImpl(this.baseUrl);

  @override
  bool matches(String _, String url) {
    return url.startsWith(baseUrl);
  }
}
