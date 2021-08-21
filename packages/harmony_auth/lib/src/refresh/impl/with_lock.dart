import 'dart:async';

import 'package:harmony_auth/harmony_auth.dart';
import 'package:meta/meta.dart';

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
}
