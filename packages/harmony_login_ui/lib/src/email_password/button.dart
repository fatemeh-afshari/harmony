import 'package:flutter/material.dart';
import 'package:harmony_login_ui/src/email_password/login.dart';

class EmailPasswordLoginButton extends StatefulWidget {
  const EmailPasswordLoginButton({
    Key? key,
  }) : super(key: key);

  @override
  _EmailPasswordLoginButtonState createState() =>
      _EmailPasswordLoginButtonState();
}

class _EmailPasswordLoginButtonState extends State<EmailPasswordLoginButton> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _loading ? null : _onPressed,
      label: const Text('Login With Email'),
      icon: const Image(
        image: AssetImage('asset/image/email.png'),
        width: 32,
        height: 32,
      ),
    );
  }

  Future<void> _onPressed() async {
    setState(() => _loading = true);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const LoginUIEPLogin(),
      ),
    );
    setState(() => _loading = false);
  }
}
