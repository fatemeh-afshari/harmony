import 'package:meta/meta.dart';

import '../base/base.dart';


@internal
class AuthMatcherUrlImpl extends AbstractMethodUrlAuthMatcher {
  final Pattern urlPattern;

  const AuthMatcherUrlImpl(this.urlPattern);

  @override
  bool matches(String _, String url) {
    if (urlPattern is String) {
      return urlPattern == url;
    } else {
      final match = urlPattern.matchAsPrefix(url);
      return match != null && match.end == url.length;
    }
  }
}
