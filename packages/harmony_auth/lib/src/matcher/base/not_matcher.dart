import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../matcher.dart';
import 'abstract_matcher.dart';

@internal
class NotAuthMatcher extends AbstractAuthMatcher {
  final AuthMatcher m;

  const NotAuthMatcher(this.m);

  @override
  bool matchesRequest(RequestOptions request) => !m.matchesRequest(request);
}
