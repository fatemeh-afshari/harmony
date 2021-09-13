import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../exception/exception.dart';
import '../provider.dart';

/// google provider
class FireProviderGoogleImpl implements FireProvider {
  static const _name = 'google';

  const FireProviderGoogleImpl();

  @override
  Future<FireProviderNative> native() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      throw AssertionError();
    }

    final google = GoogleSignIn();
    final account = await google.signIn();
    if (account != null) {
      final auth = await account.authentication;
      var credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      return FireProviderNative(
        credential: credential,
        info: FireProviderInfo(
          provider: _name,
        ),
      );
    } else {
      throw FireCancelledException();
    }
  }

  @override
  Future<FireProviderWeb> web() async {
    if (!kIsWeb) throw AssertionError();

    return FireProviderWeb(
      provider: GoogleAuthProvider(),
      info: FireProviderInfo(
        provider: _name,
      ),
    );
  }
}
