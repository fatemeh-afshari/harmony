import 'dart:async';

import 'package:harmony_auth/src/token/token.dart';
import 'package:meta/meta.dart';

import '../storage.dart';

@internal
class AuthStorageWithLockImpl implements AuthStorage {
  final AuthStorage storage;

  AuthStorageWithLockImpl(this.storage);

  /// no errors are permitted
  Completer<void>? _completer;

  @override
  Future<AuthToken?> geToken() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
    try {
      return await storage.geToken();
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
      await storage.removeTokens();
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
      await storage.setTokens(token);
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }
}
