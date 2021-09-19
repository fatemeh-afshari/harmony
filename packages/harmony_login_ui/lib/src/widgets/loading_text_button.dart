import 'package:flutter/material.dart';

class LoginUILoadingTextButton extends StatelessWidget {
  final String title;
  final bool loading;
  final void Function()? onPressed;
  final bool showLoading;

  const LoginUILoadingTextButton({
    Key? key,
    required this.title,
    this.loading = false,
    this.onPressed,
    this.showLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: loading ? null : onPressed,
      child: (showLoading && loading) ? LinearProgressIndicator() : Text(title),
    );
  }
}
