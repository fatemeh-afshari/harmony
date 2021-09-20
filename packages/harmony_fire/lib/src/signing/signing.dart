import 'dart:async';

import '../provider/provider.dart';
import 'impl/standard.dart';

abstract class FireSigning {
  /// standard implementation
  const factory FireSigning() = FireSigningStandardImpl;

  /// check to see if is signed in.
  bool isSignedIn();

  /// if is signed out, it won't do anything.
  Future<void> signOut();

  /// if is signed in, it will sign out first.
  Future<FireSigningInfo> signInUpSocial(FireProvider provider);

  /// if is already singed in anonymously it will not do any thing.
  /// if is of other kind it will sign out first.
  Future<void> signInUpAnonymously();
}

/// signing info
class FireSigningInfo {
  final String provider;
  final String uid;
  final String email;
  final bool emailVerified;
  final String? displayName;

  const FireSigningInfo({
    required this.provider,
    required this.uid,
    required this.email,
    required this.emailVerified,
    required this.displayName,
  });
}
