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

  /// last successful attempt to refresh token
  DateTime? _last;

  @override
  Future<void> refreshTokens() async {
    if (_last == null || DateTime.now().difference(_last!) > duration) {
      _last = null;
      await base.refreshTokens();
      _last = DateTime.now();
    }
  }

  @override
  AuthMatcher get refreshTokensMatcher => base.refreshTokensMatcher;

  @override
  Future<AuthToken?> getToken() => base.getToken();

  @override
  Future<void> removeToken() async {
    _last = null;
    await base.removeToken();
  }

  @override
  Future<void> setToken(AuthToken token) async {
    _last = null;
    await base.setToken(token);
  }
}
