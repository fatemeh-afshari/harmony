import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_fire/harmony_fire.dart';
import 'package:harmony_login/harmony_login.dart';

class LoginUISocial extends StatelessWidget {
  final String name;
  final String title;
  final String icon;

  final AuthRepository authRepository;
  final LoginSystem loginSystem;
  final FireSigning fireSigning;

  final void Function(String email, String? name) onSuccess;
  final void Function() onCancelled;
  final void Function(Object error) onError;

  const LoginUISocial.apple({
    Key? key,
    required AuthRepository authRepository,
    required LoginSystem loginSystem,
    required FireSigning fireSigning,
    required void Function(String email, String? name) onSuccess,
    required void Function() onCancelled,
    required void Function(Object error) onError,
  }) : this._internal(
          name: 'apple',
          title: 'Login with Apple',
          icon: 'asset/image/apple.png',
          authRepository: authRepository,
          loginSystem: loginSystem,
          fireSigning: fireSigning,
          onSuccess: onSuccess,
          onCancelled: onCancelled,
          onError: onError,
        );

  const LoginUISocial.facebook({
    Key? key,
    required AuthRepository authRepository,
    required LoginSystem loginSystem,
    required FireSigning fireSigning,
    required void Function(String email, String? name) onSuccess,
    required void Function() onCancelled,
    required void Function(Object error) onError,
  }) : this._internal(
          name: 'facebook',
          title: 'Login with Facebook',
          icon: 'asset/image/facebook.png',
          authRepository: authRepository,
          loginSystem: loginSystem,
          fireSigning: fireSigning,
          onSuccess: onSuccess,
          onCancelled: onCancelled,
          onError: onError,
        );

  const LoginUISocial.google({
    Key? key,
    required AuthRepository authRepository,
    required LoginSystem loginSystem,
    required FireSigning fireSigning,
    required void Function(String email, String? name) onSuccess,
    required void Function() onCancelled,
    required void Function(Object error) onError,
  }) : this._internal(
          name: 'google',
          title: 'Login with Google',
          icon: 'asset/image/google.png',
          authRepository: authRepository,
          loginSystem: loginSystem,
          fireSigning: fireSigning,
          onSuccess: onSuccess,
          onCancelled: onCancelled,
          onError: onError,
        );

  const LoginUISocial._internal({
    Key? key,
    required this.name,
    required this.title,
    required this.icon,
    required this.authRepository,
    required this.loginSystem,
    required this.fireSigning,
    required this.onSuccess,
    required this.onCancelled,
    required this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _onPressed,
      label: Text(title),
      icon: Image(
        image: AssetImage(icon),
        width: 32,
        height: 32,
      ),
    );
  }

  Future<void> _onPressed() async {
    try {
      final provider = FireProvider.of(name);
      final signingInfo = await fireSigning.signInUpSocial(provider);
      try {
        final social = loginSystem.social();
        final result = await social.login(
          signingInfo.provider,
          signingInfo.email,
        );
        await authRepository.setToken(AuthToken(
          refresh: result.refresh,
          access: result.access,
        ));
        onSuccess(signingInfo.email, signingInfo.displayName);
      } catch (_) {
        try {
          await fireSigning.signOut();
        } catch (__) {}
        rethrow;
      }
    } on FireCancelledException {
      onCancelled();
    } catch (e) {
      onError(e);
    }
  }
}
