import 'package:meta/meta.dart';

import '../matcher.dart';

import 'abstract_matcher.dart';

@internal
class UnionAuthMatcher extends AbstractAuthMatcher {
  final AuthMatcher m1;
  final AuthMatcher m2;

  const UnionAuthMatcher(this.m1, this.m2);

  @override
  bool matches(String method, String url) =>
      m1.matches(method, url) || m2.matches(method, url);
}
