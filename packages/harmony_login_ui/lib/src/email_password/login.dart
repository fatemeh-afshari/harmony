import 'package:flutter/material.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:harmony_login/harmony_login.dart';
import 'package:harmony_login_ui/src/email_password/widgets/email_form_field.dart';
import 'package:harmony_login_ui/src/email_password/widgets/loading_elevated_button.dart';
import 'package:harmony_login_ui/src/email_password/widgets/loading_text_button.dart';
import 'package:harmony_login_ui/src/email_password/widgets/password_form_field.dart';

class LoginUIEPLogin extends StatefulWidget {
  static const route = '/harmony_login_ui/email_password/login';

  final AuthRepository authRepository;
  final LoginSystem loginSystem;

  const LoginUIEPLogin({
    Key? key,
    required this.authRepository,
    required this.loginSystem,
  }) : super(key: key);

  @override
  _LoginUIEPLoginState createState() => _LoginUIEPLoginState();
}

class _LoginUIEPLoginState extends State<LoginUIEPLogin> {
  final _formKey = GlobalKey<FormState>();

  var _loading = false;

  String? _email;
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
                EmailFromField(
                  onSaved: (value) => _email = value,
                ),
                const SizedBox(height: 32),
                PasswordFromField(
                  onSaved: (value) => _password = value,
                ),
                const SizedBox(height: 32),
                LoginUILoadingTextButton(
                  title: 'Register',
                  onPressed: _loading ? null : _register,
                ),
                const SizedBox(height: 32),
                LoginUILoadingTextButton(
                  title: 'Reset Password',
                  onPressed: _loading ? null : _resetPassword,
                ),
                const Spacer(),
                LoginUILoadingElevatedButton(
                  title: 'Login',
                  loading: _loading,
                  onPressed: _login,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    // setState(() => _loading = true);
    // final result = await Navigator.of(context).push(
    //   MaterialPageRoute<Object?>(
    //     builder: (context) => const LoginUIEPRegister(),
    //   ),
    // );
    // if (result is String) {
    //   Navigator.of(context).pop(result);
    // } else {
    //   Navigator.of(context).pop();
    // }
    // setState(() => _loading = false);
  }

  Future<void> _resetPassword() async {
    // setState(() => _loading = true);
    // await Navigator.of(context).push(
    //   MaterialPageRoute<void>(
    //     builder: (context) => const LoginUIEPResetPassword(),
    //   ),
    // );
    // setState(() => _loading = false);
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final emailPassword = widget.loginSystem.emailPassword();
        final result = await emailPassword.login(
          email: _email!,
          password: _password!,
        );
        await widget.authRepository.setToken(AuthToken(
          refresh: result.refresh,
          access: result.access,
        ));
        Navigator.of(context).pop(_email!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form has problems')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A problem occurred')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
}
