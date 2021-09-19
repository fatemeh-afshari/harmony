import 'package:flutter/material.dart';

class LoginUIEnabledTextButton extends StatelessWidget {
  final String title;
  final bool loading;
  final void Function()? onPressed;

  const LoginUIEnabledTextButton({
    Key? key,
    required this.title,
    this.loading = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: loading ? null : onPressed,
      child: Text(title),
    );
  }
}
