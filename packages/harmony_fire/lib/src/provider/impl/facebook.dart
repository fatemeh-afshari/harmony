import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../exception/exception.dart';
import '../provider.dart';

/// facebook provider
class FireProviderFacebookImpl implements FireProvider {
  @override
  final name = 'facebook';

  const FireProviderFacebookImpl();

  @override
  Future<bool> get isAvailable async => true;

  @override
  Future<FireProviderNative> native() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      throw AssertionError();
    }

    final result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken!;
      var credential = FacebookAuthProvider.credential(accessToken.token);
      return FireProviderNative(
        credential: credential,
        info: FireProviderInfo(
          provider: name,
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
      provider: FacebookAuthProvider()
        ..addScope('email')
        ..setCustomParameters(<dynamic, dynamic>{
          'display': 'popup',
        }),
      info: FireProviderInfo(
        provider: name,
      ),
    );
  }
}
