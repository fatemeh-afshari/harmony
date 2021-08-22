import 'dart:async';

import 'package:meta/meta.dart';

import '../../matcher/matcher.dart';
import '../../token/token.dart';
import '../repository.dart';

@internal
class AuthRepositoryDebounceImpl implements AuthRepository {
  final AuthRepository base;
  final Duration duration;

  AuthRepositoryDebounceImpl(
    this.base, {
    required this.duration,
  });

  @override
  Future<void> refreshTokens() async {
    // todo
    throw 0;
  }

  @override
  AuthMatcher get refreshTokensMatcher => base.refreshTokensMatcher;

  @override
  Future<AuthToken?> getToken() async {
    // todo
    throw 0;
  }

  @override
  Future<void> removeToken() async {
    // todo
    throw 0;
  }

  @override
  Future<void> setToken(AuthToken token) async {
    // todo
    throw 0;
  }
}
