import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_fire/harmony_fire.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/widgets/loading_elevated_icon_button.dart';

class SocialLoginButton extends StatefulWidget {
  final String provider;
  final String title;
  final String icon;

  final AuthRepository authRepository;
  final LoginSystem loginSystem;
  final FireSigning fireSigning;

  final void Function(
    String provider,
    String email,
    String? displayName,
  ) onSuccess;

  const SocialLoginButton.apple({
    Key? key,
    required AuthRepository authRepository,
    required LoginSystem loginSystem,
    required FireSigning fireSigning,
    required void Function(
      String provider,
      String email,
      String? displayName,
    )
        onSuccess,
  }) : this._internal(
          key: key,
          provider: 'apple',
          title: 'Login with Apple',
          icon: 'asset/image/harmony_login_ui_apple.svg',
          authRepository: authRepository,
          loginSystem: loginSystem,
          fireSigning: fireSigning,
          onSuccess: onSuccess,
        );

  const SocialLoginButton.facebook({
    Key? key,
    required AuthRepository authRepository,
    required LoginSystem loginSystem,
    required FireSigning fireSigning,
    required void Function(
      String provider,
      String email,
      String? displayName,
    )
        onSuccess,
  }) : this._internal(
          key: key,
          provider: 'facebook',
          title: 'Login with Facebook',
          icon: 'asset/image/harmony_login_ui_facebook.svg',
          authRepository: authRepository,
          loginSystem: loginSystem,
          fireSigning: fireSigning,
          onSuccess: onSuccess,
        );

  const SocialLoginButton.google({
    Key? key,
    required AuthRepository authRepository,
    required LoginSystem loginSystem,
    required FireSigning fireSigning,
    required void Function(
      String provider,
      String email,
      String? displayName,
    )
        onSuccess,
  }) : this._internal(
          key: key,
          provider: 'google',
          title: 'Login with Google',
          icon: 'asset/image/harmony_login_ui_google.svg',
          authRepository: authRepository,
          loginSystem: loginSystem,
          fireSigning: fireSigning,
          onSuccess: onSuccess,
        );

  const SocialLoginButton._internal({
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
  _SocialLoginButtonState createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return LoginUILoadingElevatedIconButton(
      title: widget.title,
      icon: SvgPicture.asset(
        widget.icon,
        package: 'harmony_login_ui',
        width: 24,
        height: 24,
      ),
      loading: _loading,
      showLoading: true,
      onPressed: _onPressed,
    );
  }

  Future<void> _onPressed() async {
    setState(() => _loading = true);
    try {
      final provider = widget.fireSigning.providerOf(widget.provider);
      final signingInfo = await widget.fireSigning.signInUpSocial(provider);
      try {
        final social = widget.loginSystem.social();
        final result = await social.login(
          provider: signingInfo.provider,
          email: signingInfo.email,
        );
        await widget.authRepository.setToken(AuthToken(
          refresh: result.refresh,
          access: result.access,
        ));
        widget.onSuccess(
          'social_${signingInfo.provider}',
          signingInfo.email,
          signingInfo.displayName,
        );
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
        const SnackBar(content: Text('A problem occurred')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
}
