import 'package:flutter/material.dart';

class LoginUIApple extends StatelessWidget {
  const LoginUIApple({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      label: const Text('Login With Apple'),
      icon: const Image(
        image: AssetImage('asset/image/apple.png'),
        width: 32,
        height: 32,
      ),
    );
  }
}
