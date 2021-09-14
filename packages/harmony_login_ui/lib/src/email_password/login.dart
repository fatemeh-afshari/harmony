import 'package:flutter/material.dart';
import 'package:harmony_login_ui/src/email_password/register.dart';
import 'package:harmony_login_ui/src/email_password/reset_password.dart';

class LoginUIEPLogin extends StatefulWidget {
  const LoginUIEPLogin({
    Key? key,
  }) : super(key: key);

  @override
  _LoginUIEPLoginState createState() => _LoginUIEPLoginState();
}

class _LoginUIEPLoginState extends State<LoginUIEPLogin> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  autofillHints: const ['email'],
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  autofillHints: const ['password'],
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: _loading ? null : _register,
                  child: const Text('Register'),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: _loading ? null : _resetPassword,
                  child: const Text('Reset Password'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const LoginUIEPRegister(),
      ),
    );
  }

  void _resetPassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const LoginUIEPResetPassword(),
      ),
    );
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }
}