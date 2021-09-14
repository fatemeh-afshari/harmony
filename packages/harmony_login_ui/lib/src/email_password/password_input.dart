import 'package:flutter/material.dart';

class _Password {
  final String pass;
  final bool isObscure;

  const _Password({
    required this.pass,
    required this.isObscure,
  });

  const _Password.empty({
    required bool isObscure,
  }) : this(
          pass: '',
          isObscure: isObscure,
        );

  @override
  String toString() => '_Password{pass: $pass}';
}

class PasswordFromField extends FormField<_Password> {
  PasswordFromField({
    Key? key,
    String? Function(String pass)? validator,
    void Function(String pass)? onSaved,
    String? passwordHint,
    bool showObscureIcon = true,
  }) : super(
          key: key,
          validator: (_Password? value) {
            final pair = value!;
            final pass = pair.pass;
            return validator?.call(pass);
          },
          onSaved: (_Password? value) {
            final pair = value!;
            final pass = pair.pass;
            onSaved?.call(pass);
          },
          initialValue: _Password.empty(
            isObscure: showObscureIcon,
          ),
          builder: (field) {
            final error = field.errorText;
            final pair = field.value!;
            final pass = pair.pass;
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
                            pass: pass,
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
                  pass: value.trim(),
                  isObscure: isObscure,
                ));
              },
            );
          },
        );
}
