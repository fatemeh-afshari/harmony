import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/widgets/email_form_field.dart';
import 'package:harmony_login_ui/src/widgets/loading_elevated_button.dart';

class LoginUIEmailPasswordResetPassword extends StatefulWidget {
  static const route = '/harmony_login_ui/email_password/reset_password';

  final AuthRepository authRepository;
  final LoginSystem loginSystem;

  const LoginUIEmailPasswordResetPassword({
    Key? key,
    required this.authRepository,
    required this.loginSystem,
  }) : super(key: key);

  @override
  _LoginUIEmailPasswordResetPasswordState createState() =>
      _LoginUIEmailPasswordResetPasswordState();
}

class _LoginUIEmailPasswordResetPasswordState
    extends State<LoginUIEmailPasswordResetPassword> {
  final _formKey = GlobalKey<FormState>();

  var _loading = false;

  String? _email;

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
                EmailFromField(
                  onSaved: (value) => _email = value,
                ),
                const Spacer(),
                LoginUILoadingElevatedButton(
                  title: 'Reset Password',
                  loading: _loading,
                  showLoading: true,
                  onPressed: _login,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final emailPassword = widget.loginSystem.emailPassword();
        await emailPassword.resetPassword(
          email: _email!,
        );
        // todo
        await Future<void>.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('TODO')),
        );
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
