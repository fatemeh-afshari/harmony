import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/email_password/pages/change_password_page.dart';
import 'package:harmony_login_ui/src/widgets/loading_text_button.dart';

class ChangePasswordButton extends StatefulWidget {
  final AuthRepository authRepository;
  final LoginSystem loginSystem;

  final void Function() onSuccess;

  const ChangePasswordButton({
    Key? key,
    required this.authRepository,
    required this.loginSystem,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _ChangePasswordButtonState createState() => _ChangePasswordButtonState();
}

class _ChangePasswordButtonState extends State<ChangePasswordButton> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return LoginUILoadingTextButton(
      title: 'Change Password',
      loading: _loading,
      showLoading: false,
      onPressed: _onPressed,
    );
  }

  Future<void> _onPressed() async {
    setState(() => _loading = true);
    final result = await Navigator.of(context).push(
      MaterialPageRoute<Object?>(
        settings: RouteSettings(
          name: LoginUIEmailPasswordChangePassword.route,
        ),
        builder: (context) => LoginUIEmailPasswordChangePassword(
          authRepository: widget.authRepository,
          loginSystem: widget.loginSystem,
        ),
      ),
    );
    if (result is Map<String, dynamic>) {
      assert(result['passwordChanged'] == true);
      widget.onSuccess();
    }
    setState(() => _loading = false);
  }
}
