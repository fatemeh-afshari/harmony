import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/widgets/loading_elevated_button.dart';
import 'package:harmony_login_ui/src/widgets/password_pair_form_field.dart';

class LoginUIEmailPasswordResetPasswordNewPassword extends StatefulWidget {
  static const route =
      '/harmony_login_ui/email_password/login/reset_password/new_password/';

  final AuthRepository authRepository;
  final LoginSystem loginSystem;
  final String email;
  final String code;

  const LoginUIEmailPasswordResetPasswordNewPassword({
    Key? key,
    required this.authRepository,
    required this.loginSystem,
    required this.email,
    required this.code,
  }) : super(key: key);

  @override
  _LoginUIEmailPasswordResetPasswordNewPasswordState createState() =>
      _LoginUIEmailPasswordResetPasswordNewPasswordState();
}

class _LoginUIEmailPasswordResetPasswordNewPasswordState
    extends State<LoginUIEmailPasswordResetPasswordNewPassword> {
  final _formKey = GlobalKey<FormState>();

  var _loading = false;

  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginUIPasswordPairFromField(
                  hasNext: false,
                  enabled: !_loading,
                  passwordHint: 'New Password',
                  confirmHint: 'Confirm New Password',
                  onSaved: (value) => _password = value,
                  onSubmit: _submit,
                ),
                const Spacer(),
                LoginUILoadingElevatedButton(
                  title: 'Set New Password',
                  loading: _loading,
                  showLoading: true,
                  onPressed: _submit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final emailPassword = widget.loginSystem.emailPassword();
        await emailPassword.resetPasswordNewPassword(
          email: widget.email,
          code: widget.code,
          password: _password!,
        );
        Navigator.of(context).pop(<String, dynamic>{
          'logged_in': true,
          'registered': false,
          'email': widget.email,
          'password_reset': true,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form has problems')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A problem occurred')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
}
