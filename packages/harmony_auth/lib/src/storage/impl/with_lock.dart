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
  Future<AuthToken?> get() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
    try {
      return await storage.get();
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }

  @override
  Future<void> remove() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
    try {
      await storage.remove();
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }

  @override
  Future<void> set(AuthToken token) async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
    try {
      await storage.set(token);
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }
}
