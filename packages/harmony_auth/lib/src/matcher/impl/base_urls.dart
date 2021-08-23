import 'package:meta/meta.dart';

import '../base/base.dart';

@internal
class AuthMatcherBaseUrlsImpl extends AbstractMethodUrlAuthMatcher {
  final Set<String> baseUrls;

  const AuthMatcherBaseUrlsImpl(this.baseUrls);

  @override
  bool matches(String _, String url) {
    for (final baseUrl in baseUrls) {
      if (url.startsWith(baseUrl)) return true;
    }
    return false;
  }
}
