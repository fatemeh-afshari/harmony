import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../matcher.dart';
import 'abstract_matcher.dart';

@internal
class DifferenceAuthMatcher extends AbstractAuthMatcher {
  final AuthMatcher m1;
  final AuthMatcher m2;

  const DifferenceAuthMatcher(this.m1, this.m2);

  @override
  bool matchesRequest(RequestOptions request) =>
      m1.matchesRequest(request) && !m2.matchesRequest(request);
}
