import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_fire/harmony_fire.dart';
import 'package:harmony_login/harmony_login.dart';

class LoginUIGoogle extends StatelessWidget {
  final AuthRepository authRepository;
  final LoginSystem loginSystem;
  final FireSigning fireSigning;

  final void Function(String email, String? name) onSuccess;
  final void Function() onCancelled;
  final void Function(Object error) onError;

  const LoginUIGoogle({
    Key? key,
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
      label: const Text('Login With Google'),
      icon: const Image(
        image: AssetImage('asset/image/google.png'),
        width: 32,
        height: 32,
      ),
    );
  }

  Future<void> _onPressed() async {
    try {
      const provider = FireProvider.google();
      final signingInfo = await fireSigning.signInUpSocial(provider);
      try {
        final social = loginSystem.social();
        final result = await social.login(
          'google',
          signingInfo.email,
        );
        authRepository.setToken(AuthToken(
          refresh: result.refresh,
          access: result.access,
        ));
        onSuccess(signingInfo.email, signingInfo.displayName);
      } catch (_) {
        try {
          fireSigning.signOut();
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
