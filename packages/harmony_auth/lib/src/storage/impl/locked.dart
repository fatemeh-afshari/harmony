import 'dart:async';

import 'package:harmony_auth/src/token/token.dart';
import 'package:meta/meta.dart';

import '../storage.dart';

@internal
class AuthStorageLockedImpl implements AuthStorage {
  final AuthStorage base;

  AuthStorageLockedImpl(this.base);

  /// no errors are permitted
  Completer<void>? _completer;

  @override
  Future<AuthToken?> geToken() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
    try {
      return await base.geToken();
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }

  @override
  Future<void> removeTokens() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
    try {
      await base.removeTokens();
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }

  @override
  Future<void> setTokens(AuthToken token) async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
    try {
      await base.setTokens(token);
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }
}
