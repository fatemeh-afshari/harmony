import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../matcher/matcher.dart';
import '../rest.dart';

@internal
class AuthRestGeneralImpl implements AuthRest {
  final Dio dio;

  @override
  final AuthMatcherBase refreshTokensMatcher;

  final Future<AuthRestToken> Function(Dio dio, String refresh) lambda;

  const AuthRestGeneralImpl({
    required this.dio,
    required this.refreshTokensMatcher,
    required this.lambda,
  });

  @override
  Future<AuthRestToken> refreshTokens(String refresh) => lambda(dio, refresh);
}
