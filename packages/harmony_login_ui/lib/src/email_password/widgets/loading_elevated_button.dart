import 'package:flutter/material.dart';

class LoginUILoadingElevatedButton extends StatelessWidget {
  final String title;
  final bool loading;
  final void Function()? onPressed;

  const LoginUILoadingElevatedButton({
    Key? key,
    this.title = 'Submit',
    this.loading = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading ? const LinearProgressIndicator() : Text(title),
    );
  }
}
