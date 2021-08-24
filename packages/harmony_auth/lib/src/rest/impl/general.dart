import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../matcher/matcher.dart';
import '../../token/token.dart';
import '../rest.dart';

@internal
class AuthRestGeneralImpl implements AuthRest {
  final Dio dio;

  @override
  final AuthMatcher refreshTokensMatcher;

  final Future<AuthToken> Function(Dio dio, AuthToken token) refresh;

  const AuthRestGeneralImpl({
    required this.dio,
    required this.refreshTokensMatcher,
    required this.refresh,
  });

  @override
  Future<AuthToken> refreshTokens(AuthToken token) => refresh(dio, token);
}
