import 'package:flutter/material.dart';

class LoginUIFacebook extends StatelessWidget {
  const LoginUIFacebook({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      label: const Text('Login With Facebook'),
      icon: const Image(
        image: AssetImage('asset/image/facebook.png'),
        width: 32,
        height: 32,
      ),
    );
  }
}
