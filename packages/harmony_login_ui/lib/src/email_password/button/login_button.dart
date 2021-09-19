import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/email_password/pages/login_page.dart';
import 'package:harmony_login_ui/src/widgets/loading_elevated_icon_button.dart';

class EmailPasswordLoginButton extends StatefulWidget {
  final AuthRepository authRepository;
  final LoginSystem loginSystem;

  final void Function(
    String provider,
    String email,
    bool isRegistered,
  ) onSuccess;

  const EmailPasswordLoginButton({
    Key? key,
    required this.authRepository,
    required this.loginSystem,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _EmailPasswordLoginButtonState createState() =>
      _EmailPasswordLoginButtonState();
}

class _EmailPasswordLoginButtonState extends State<EmailPasswordLoginButton> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return LoginUILoadingElevatedIconButton(
      title: 'Login With Email',
      icon: SvgPicture.asset(
        'asset/image/harmony_login_ui_email.svg',
        package: 'harmony_login_ui',
        width: 24,
        height: 24,
      ),
      loading: _loading,
      showLoading: false,
      onPressed: _onPressed,
    );
  }

  Future<void> _onPressed() async {
    setState(() => _loading = true);
    final result = await Navigator.of(context).push(
      MaterialPageRoute<Object?>(
        settings: const RouteSettings(
          name: LoginUIEmailPasswordLogin.route,
        ),
        builder: (context) => LoginUIEmailPasswordLogin(
          authRepository: widget.authRepository,
          loginSystem: widget.loginSystem,
        ),
      ),
    );
    if (result is Map<String, dynamic>) {
      assert(result['logged_in'] == true);
      widget.onSuccess(
        'email_password',
        result['email'] as String,
        result['registered'] as bool,
      );
    }
    setState(() => _loading = false);
  }
}
