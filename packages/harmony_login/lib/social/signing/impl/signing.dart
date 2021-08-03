import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../exception/exception.dart';
import '../../provider/impl/apple.dart';
import '../../provider/provider.dart';
import '../signing.dart';

class FireSigningImpl implements FireSigning {
  static const _IS_UNDER_SANCTION = true;

  FireSigningImpl({
    required this.logger,
  });

  final Logger logger;

  late final bool _isAppleSignInAvailable;

  @override
  Future<void> initialize() async {
    _isAppleSignInAvailable = await FireProviderAppleImpl.isAvailable;
  }

  @override
  bool get isAppleSignInAvailable => _isAppleSignInAvailable;

  @override
  bool isSignedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  Future<void> signOut() async {
    _log('signOut');
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
        _log('signOut succeeded');
      } else {
        _log('signOut is not needed');
      }
    } catch (e) {
      if (!_IS_UNDER_SANCTION) {
        _log('signOut error {$e}');
        rethrow;
      } else {
        _log('signOut SANCTION SUPPRESSED {$e}');
      }
    }
  }

  @override
  Future<FireSigningInfo> socialSignInUp(FireProvider provider) async {
    _log('socialSignInUp');
    await signOut();
    if (kIsWeb) {
      _log('socialSignInUp web');
      final web = await provider.web();
      await _signInUpWeb(web.provider);
      return _info(web.extra);
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
        _log('socialSignInUp native');
        final native = await provider.native();
        await _signInUpNative(native.credential);
        return _info(native.extra);
      } else {
        throw AssertionError();
      }
    }
  }

  @override
  Future<void> anonymousSignInUp() async {
    _log('anonymousSignInUp');
    try {
      await FirebaseAuth.instance.signInAnonymously();
      _log('anonymousSignInUp succeeded');
    } catch (e) {
      if (!_IS_UNDER_SANCTION) {
        _log('anonymousSignInUp error {$e}');
        rethrow;
      } else {
        _log('anonymousSignInUp  SANCTION SUPPRESSED {$e}');
      }
    }
  }

  Future<String?> _signInUpNative(AuthCredential credential) async {
    if (kIsWeb) throw AssertionError();
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _signInUpWeb(AuthProvider provider) async {
    if (!kIsWeb) throw AssertionError();
    try {
      await FirebaseAuth.instance.signInWithPopup(provider);
    } catch (e) {
      _log('_signInUpWeb error {$e}');
      // TD what will happen if failed ?
      throw FireCancelledException();
    }
  }

  FireSigningInfo _info(FireProviderExtra extra) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FireSigningInfo(
        provider: extra.provider,
        uid: user.uid,
        email: user.email!,
        emailVerified: user.emailVerified,
        displayName: extra.displayName ?? user.displayName,
      );
    } else {
      throw AssertionError();
    }
  }

  void _log(String message) {
    logger.i('harmony_login fire signing: $message');
  }
}
