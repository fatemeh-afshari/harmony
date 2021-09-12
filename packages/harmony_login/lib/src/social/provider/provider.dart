import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

import 'impl/apple.dart';
import 'impl/facebook.dart';
import 'impl/google.dart';

/// extra information
class FireProviderExtra {
  final String provider;
  final String? displayName;

  const FireProviderExtra({
    required this.provider,
    this.displayName,
  });
}

/// native with extra information
class FireProviderNative {
  final AuthCredential credential;
  final FireProviderExtra extra;

  const FireProviderNative({
    required this.credential,
    required this.extra,
  });
}

/// web with extra information
class FireProviderWeb {
  final AuthProvider provider;
  final FireProviderExtra extra;

  const FireProviderWeb({
    required this.provider,
    required this.extra,
  });
}

/// social providers
abstract class FireProvider {
  const factory FireProvider.apple() = FireProviderAppleImpl;

  const factory FireProvider.facebook() = FireProviderFacebookImpl;

  const factory FireProvider.google() = FireProviderGoogleImpl;

  /// native oauth login
  Future<FireProviderNative> native();

  /// web oauth login
  Future<FireProviderWeb> web();
}
