import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_fire/harmony_fire.dart';
import 'package:harmony_login/harmony_login.dart';

class LoginUISocial extends StatefulWidget {
  final String provider;
  final String title;
  final String icon;

  final AuthRepository authRepository;
  final LoginSystem loginSystem;
  final FireSigning fireSigning;

  final void Function(String email, String? provider) onSuccess;

  const LoginUISocial.apple({
    Key? key,
    required AuthRepository authRepository,
    required LoginSystem loginSystem,
    required FireSigning fireSigning,
    required void Function(String email, String? provider) onSuccess,
    required void Function() onCancelled,
    required void Function(Object error) onError,
  }) : this._internal(
          key: key,
          provider: 'apple',
          title: 'Login with Apple',
          icon: 'asset/image/apple.png',
          authRepository: authRepository,
          loginSystem: loginSystem,
          fireSigning: fireSigning,
          onSuccess: onSuccess,
        );

  const LoginUISocial.facebook({
    Key? key,
    required AuthRepository authRepository,
    required LoginSystem loginSystem,
    required FireSigning fireSigning,
    required void Function(String email, String? provider) onSuccess,
    required void Function() onCancelled,
    required void Function(Object error) onError,
  }) : this._internal(
          key: key,
          provider: 'facebook',
          title: 'Login with Facebook',
          icon: 'asset/image/facebook.png',
          authRepository: authRepository,
          loginSystem: loginSystem,
          fireSigning: fireSigning,
          onSuccess: onSuccess,
        );

  const LoginUISocial.google({
    Key? key,
    required AuthRepository authRepository,
    required LoginSystem loginSystem,
    required FireSigning fireSigning,
    required void Function(String email, String? provider) onSuccess,
    required void Function() onCancelled,
    required void Function(Object error) onError,
  }) : this._internal(
          key: key,
          provider: 'google',
          title: 'Login with Google',
          icon: 'asset/image/google.png',
          authRepository: authRepository,
          loginSystem: loginSystem,
          fireSigning: fireSigning,
          onSuccess: onSuccess,
        );

  const LoginUISocial._internal({
    Key? key,
    required this.provider,
    required this.title,
    required this.icon,
    required this.authRepository,
    required this.loginSystem,
    required this.fireSigning,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _LoginUISocialState createState() => _LoginUISocialState();
}

class _LoginUISocialState extends State<LoginUISocial> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _loading ? null : _onPressed,
      label: Text(widget.title),
      icon: Image(
        image: AssetImage(widget.icon),
        width: 32,
        height: 32,
      ),
    );
  }

  Future<void> _onPressed() async {
    setState(() => _loading = true);
    try {
      final provider = FireProvider.of(widget.provider);
      final signingInfo = await widget.fireSigning.signInUpSocial(provider);
      try {
        final social = widget.loginSystem.social();
        final result = await social.login(
          signingInfo.provider,
          signingInfo.email,
        );
        await widget.authRepository.setToken(AuthToken(
          refresh: result.refresh,
          access: result.access,
        ));
        widget.onSuccess(signingInfo.email, signingInfo.displayName);
      } catch (_) {
        try {
          await widget.fireSigning.signOut();
        } catch (__) {}
        rethrow;
      }
    } on FireCancelledException {
      // nothing
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A problem occurred')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
}
