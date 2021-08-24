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
  Future<AuthToken?> getToken() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
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
    _completer = Completer<void>();
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
    _completer = Completer<void>();
    try {
      await base.setToken(token);
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }

  @override
  Future<AuthStatus> get status async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
    try {
      return await base.status;
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }

  @override
  Stream<AuthStatus> get statusStream => base.statusStream;

  @override
  Future<void> initializeStatusStream() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
    try {
      await base.initializeStatusStream();
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }
}
