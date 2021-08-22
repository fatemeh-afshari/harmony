import 'package:meta/meta.dart';

import '../base/base.dart';


@internal
class AuthMatcherByUrlImpl extends AbstractMethodUrlAuthMatcher {
  final bool Function(String url) matchUrl;

  const AuthMatcherByUrlImpl(this.matchUrl);

  @override
  bool matches(String _, String url) => matchUrl(url);
}
