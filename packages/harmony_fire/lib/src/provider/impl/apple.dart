import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:html' as html;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../provider.dart';

/// apple provider
class FireProviderAppleImpl implements FireProvider {
  @override
  final name = 'apple';

  const FireProviderAppleImpl();

  /// if apple sign in is available
  static Future<bool> get isAvailable async {
    if (kIsWeb) {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      if (userAgent.contains('iphone') || userAgent.contains('ipad')) {
        return true;
      } else if (userAgent.contains('android')) {
        return false;
      } else {
        final platform = html.window.navigator.platform?.toLowerCase();
        if (platform != null && platform.contains('mac')) {
          return true;
        } else {
          return false;
        }
      }
    } else if (Platform.isIOS) {
      return await SignInWithApple.isAvailable();
    } else {
      return false;
    }
  }

  /// User display name is built into it's credential,
  /// and it only send them on first login attempt:
  /// https://github.com/firebase/firebase-ios-sdk/issues/4393#issuecomment-559012512
  @override
  Future<FireProviderNative> native() async {
    if (kIsWeb || !Platform.isIOS) {
      throw AssertionError();
    }

    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    final credential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final firstName = appleCredential.givenName;
    final lastName = appleCredential.familyName;
    final displayName = (firstName == null && lastName == null)
        ? null
        : '${firstName ?? ''} ${lastName ?? ''}';

    return FireProviderNative(
      credential: credential,
      info: FireProviderInfo(
        provider: name,
        displayName: displayName,
      ),
    );
  }

  @override
  Future<FireProviderWeb> web() async {
    if (!kIsWeb) throw AssertionError();

    return FireProviderWeb(
      provider: OAuthProvider('apple.com')
        ..addScope('email')
        ..addScope('name'),
      info: FireProviderInfo(
        provider: name,
      ),
    );
  }

  String _generateNonce([int length = 32]) {
    const charset = '0123456789'
        'ABCDEFGHIJKLMNOPQRSTUVXYZ'
        'abcdefghijklmnopqrstuvwxyz'
        '-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
