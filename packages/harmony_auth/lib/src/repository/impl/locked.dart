import 'dart:async';

import 'package:meta/meta.dart';

import '../../matcher/matcher.dart';
import '../../token/token.dart';
import '../repository.dart';

@internal
class AuthRepositoryLockedImpl implements AuthRepository {
  final AuthRepository base;

  AuthRepositoryLockedImpl(this.base);

  Completer<void>? _completer;

  @override
  Future<void> refreshTokens() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer();
    try {
      await base.refreshTokens();
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }

  @override
  AuthMatcher get refreshTokensMatcher => base.refreshTokensMatcher;

  @override
  Future<AuthToken?> getToken() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer();
    try {
      return await base.getToken();
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }

  @override
  Future<void> removeToken() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer();
    try {
      await base.removeToken();
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }

  @override
  Future<void> setToken(AuthToken token) async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer();
    try {
      await base.setToken(token);
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }
}
