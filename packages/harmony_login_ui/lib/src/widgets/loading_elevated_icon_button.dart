import 'package:flutter/material.dart';

class LoginUILoadingElevatedIconButton extends StatelessWidget {
  final String title;
  final Widget icon;
  final bool loading;
  final void Function()? onPressed;

  const LoginUILoadingElevatedIconButton({
    Key? key,
    required this.title,
    required this.icon,
    this.loading = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: Row(
        children: [
          icon,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: loading
                  ? const LinearProgressIndicator()
                  : Center(
                      child: Text(title),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
