import 'dart:async';

import 'package:meta/meta.dart';

import '../../token/token.dart';
import '../refresh.dart';

@internal
class AuthRefreshWithDebounceImpl implements AuthRefresh {
  final AuthRefresh base;
  final Duration duration;

  AuthRefreshWithDebounceImpl(
    this.base, {
    required this.duration,
  });

  @override
  Future<void> refresh() async {
    // todo
    throw 0;
  }

  @override
  Future<AuthToken?> get() async {
    // todo
    throw 0;
  }

  @override
  Future<void> remove() async {
    // todo
    throw 0;
  }

  @override
  Future<void> set(AuthToken token) async {
    // todo
    throw 0;
  }
}
