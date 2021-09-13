import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

import 'impl/apple.dart';
import 'impl/facebook.dart';
import 'impl/google.dart';

/// extra information
class FireProviderInfo {
  final String provider;
  final String? displayName;

  const FireProviderInfo({
    required this.provider,
    this.displayName,
  });
}

/// native with extra information
class FireProviderNative {
  final AuthCredential credential;
  final FireProviderInfo info;

  const FireProviderNative({
    required this.credential,
    required this.info,
  });
}

/// web with extra information
class FireProviderWeb {
  final AuthProvider provider;
  final FireProviderInfo info;

  const FireProviderWeb({
    required this.provider,
    required this.info,
  });
}

/// social providers
abstract class FireProvider {
  /// apple
  const factory FireProvider.apple() = FireProviderAppleImpl;

  /// facebook
  const factory FireProvider.facebook() = FireProviderFacebookImpl;

  /// google
  const factory FireProvider.google() = FireProviderGoogleImpl;

  /// native oauth login
  Future<FireProviderNative> native();

  /// web oauth login
  Future<FireProviderWeb> web();
}
