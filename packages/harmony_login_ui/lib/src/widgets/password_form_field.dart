import 'package:flutter/material.dart';

class _Password {
  final String password;
  final bool isObscure;

  const _Password({
    required this.password,
    required this.isObscure,
  });

  const _Password.empty({
    required bool isObscure,
  }) : this(
          password: '',
          isObscure: isObscure,
        );
}

class LoginUIPasswordFromField extends FormField<_Password> {
  static String? _validator(String password) {
    if (password.length >= 4) {
      return null;
    } else {
      return 'Password is invalid';
    }
  }

  LoginUIPasswordFromField({
    Key? key,
    String? Function(String password)? validator = _validator,
    void Function(String password)? onSaved,
    String? passwordHint = 'Password',
    bool showObscureIcon = true,
  }) : super(
          key: key,
          validator: (_Password? value) {
            final pair = value!;
            final password = pair.password;
            return validator?.call(password);
          },
          onSaved: (_Password? value) {
            final pair = value!;
            final password = pair.password;
            onSaved?.call(password);
          },
          initialValue: _Password.empty(
            isObscure: showObscureIcon,
          ),
          builder: (field) {
            final error = field.errorText;
            final pair = field.value!;
            final password = pair.password;
            final isObscure = pair.isObscure;
            return TextField(
              autofillHints: const ['password'],
              keyboardType: TextInputType.visiblePassword,
              obscureText: isObscure,
              decoration: InputDecoration(
                hintText: passwordHint,
                suffixIcon: showObscureIcon
                    ? GestureDetector(
                        onTap: () {
                          field.didChange(_Password(
                            password: password,
                            isObscure: !isObscure,
                          ));
                        },
                        child: isObscure
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      )
                    : null,
                errorText: error,
              ),
              onChanged: (String value) {
                field.didChange(_Password(
                  password: value.trim(),
                  isObscure: isObscure,
                ));
              },
            );
          },
        );
}
