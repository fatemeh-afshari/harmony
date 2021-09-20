import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:meta/meta.dart';

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
///
/// todo: better impl for internals
abstract class FireProvider {
  /// apple
  @internal
  const factory FireProvider.apple() = FireProviderAppleImpl;

  /// facebook
  @internal
  const factory FireProvider.facebook() = FireProviderFacebookImpl;

  /// google
  @internal
  const factory FireProvider.google() = FireProviderGoogleImpl;

  @internal
  factory FireProvider.of(String provider) {
    switch (provider) {
      case 'apple':
        return FireProvider.apple();
      case 'facebook':
        return FireProvider.facebook();
      case 'google':
        return FireProvider.google();
      default:
        throw UnimplementedError();
    }
  }

  /// is available
  Future<bool> get isAvailable;

  /// provider name
  String get name;

  /// native oauth login
  Future<FireProviderNative> native();

  /// web oauth login
  Future<FireProviderWeb> web();
}
