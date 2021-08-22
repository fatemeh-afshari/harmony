import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../base/base.dart';


@internal
class AuthMatcherGeneralImpl extends AbstractAuthMatcher {
  final bool Function(RequestOptions request) lambda;

  const AuthMatcherGeneralImpl(this.lambda);

  @override
  bool matchesRequest(RequestOptions request) => lambda(request);
}
