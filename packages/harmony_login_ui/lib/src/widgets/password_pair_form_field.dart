import 'package:flutter/material.dart';

class _PasswordPair {
  final String password;
  final String confirm;
  final bool isObscure;

  const _PasswordPair({
    required this.password,
    required this.confirm,
    required this.isObscure,
  });

  const _PasswordPair.empty({
    required bool isObscure,
  }) : this(
          password: '',
          confirm: '',
          isObscure: isObscure,
        );
}

class LoginUIPasswordPairFromField extends FormField<_PasswordPair> {
  static String? _validator(String password) {
    if (password.length >= 4) {
      return null;
    } else {
      return 'Password is invalid';
    }
  }

  LoginUIPasswordPairFromField({
    final Key? key,
    final String? Function(String password)? validator = _validator,
    final void Function(String password)? onSaved,
    final void Function()? onSubmit,
    final bool hasNext = true,
    final bool enabled = true,
    final String? passwordHint = 'Password',
    final String? confirmHint = 'Confirm Password',
    final String? matchErrorMessage = 'Passwords do not match',
    final bool showObscureIcon = true,
  }) : super(
          key: key,
          enabled: enabled,
          validator: (_PasswordPair? value) {
            final pair = value!;
            final password = pair.password;
            final confirm = pair.confirm;
            final base = validator?.call(password);
            return base ?? (password == confirm ? null : matchErrorMessage);
          },
          onSaved: (_PasswordPair? value) {
            final pair = value!;
            final password = pair.password;
            onSaved?.call(password);
          },
          initialValue: _PasswordPair.empty(
            isObscure: showObscureIcon,
          ),
          builder: (field) {
            final error = field.errorText;
            final pair = field.value!;
            final password = pair.password;
            final confirm = pair.confirm;
            final isObscure = pair.isObscure;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofillHints: const ['password'],
                  enabled: enabled,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    hintText: passwordHint,
                    suffixIcon: showObscureIcon
                        ? GestureDetector(
                            onTap: () {
                              field.didChange(_PasswordPair(
                                password: password,
                                confirm: confirm,
                                isObscure: !isObscure,
                              ));
                            },
                            child: isObscure
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          )
                        : null,
                    errorText: (error != null && error != matchErrorMessage)
                        ? error
                        : null,
                  ),
                  onChanged: (String value) {
                    field.didChange(_PasswordPair(
                      password: value.trim(),
                      confirm: confirm,
                      isObscure: isObscure,
                    ));
                  },
                ),
                const SizedBox(height: 32),
                TextField(
                  autofillHints: const ['password'],
                  enabled: enabled,
                  textInputAction:
                      hasNext ? TextInputAction.next : TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    hintText: confirmHint,
                    suffixIcon: showObscureIcon
                        ? GestureDetector(
                            onTap: () {
                              field.didChange(_PasswordPair(
                                password: password,
                                confirm: confirm,
                                isObscure: !isObscure,
                              ));
                            },
                            child: isObscure
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          )
                        : null,
                    errorText: (error != null && error == matchErrorMessage)
                        ? matchErrorMessage
                        : null,
                  ),
                  onSubmitted: (_) {
                    onSubmit?.call();
                  },
                  onChanged: (String value) {
                    field.didChange(_PasswordPair(
                      password: password,
                      confirm: value.trim(),
                      isObscure: isObscure,
                    ));
                  },
                ),
              ],
            );
          },
        );
}
