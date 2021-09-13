import 'package:flutter/material.dart';

class LoginUIGoogle extends StatelessWidget {
  const LoginUIGoogle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      label: const Text('Login With Google'),
      icon: const Image(
        image: AssetImage('asset/image/google.png'),
        width: 32,
        height: 32,
      ),
    );
  }
}
