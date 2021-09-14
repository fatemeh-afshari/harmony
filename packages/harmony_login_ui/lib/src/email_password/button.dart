import 'package:flutter/material.dart';
import 'package:harmony_login_ui/src/email_password/login.dart';

class LoginUIEmailPasswordButton extends StatelessWidget {
  const LoginUIEmailPasswordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _onPressed(context),
      label: const Text('Login With Email'),
      icon: const Image(
        image: AssetImage('asset/image/email.png'),
        width: 32,
        height: 32,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const LoginUIEPLogin(),
      ),
    );
  }
}