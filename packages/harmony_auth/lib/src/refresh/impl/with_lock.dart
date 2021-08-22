import 'dart:async';

import 'package:meta/meta.dart';

import '../../token/token.dart';
import '../refresh.dart';

@internal
class AuthRefreshWithLockImpl implements AuthRefresh {
  final AuthRefresh base;

  AuthRefreshWithLockImpl(this.base);

  Completer<void>? _completer;

  @override
  Future<void> refresh() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer();
    try {
      await base.refresh();
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }

  @override
  Future<AuthToken?> get() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer();
    try {
      return await base.get();
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
    _completer = Completer();
    try {
      await base.remove();
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
    _completer = Completer();
    try {
      await base.set(token);
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }
}
