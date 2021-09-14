import 'package:flutter/material.dart';

class _PasswordPair {
  final String pass;
  final String confirm;
  final bool isObscure;

  const _PasswordPair({
    required this.pass,
    required this.confirm,
    required this.isObscure,
  });

  const _PasswordPair.empty({
    required bool isObscure,
  }) : this(
          pass: '',
          confirm: '',
          isObscure: isObscure,
        );

  @override
  String toString() => '_PasswordPair{pass: $pass, confirm: $confirm}';
}

class PasswordPairFromField extends FormField<_PasswordPair> {
  PasswordPairFromField({
    Key? key,
    String? Function(String pass)? validator,
    void Function(String pass)? onSaved,
    String? passwordHint,
    String? confirmHint,
    String? matchErrorMessage,
    bool showObscureIcon = true,
  }) : super(
          key: key,
          validator: (_PasswordPair? value) {
            final pair = value!;
            final pass = pair.pass;
            final confirm = pair.confirm;
            final base = validator?.call(pass);
            return base ?? (pass == confirm ? null : matchErrorMessage);
          },
          onSaved: (_PasswordPair? value) {
            final pair = value!;
            final pass = pair.pass;
            onSaved?.call(pass);
          },
          initialValue: _PasswordPair.empty(
            isObscure: showObscureIcon,
          ),
          builder: (field) {
            final error = field.errorText;
            final pair = field.value!;
            final pass = pair.pass;
            final confirm = pair.confirm;
            final isObscure = pair.isObscure;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofillHints: const ['password'],
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    hintText: passwordHint,
                    suffixIcon: showObscureIcon
                        ? GestureDetector(
                            onTap: () {
                              field.didChange(_PasswordPair(
                                pass: pass,
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
                      pass: value.trim(),
                      confirm: confirm,
                      isObscure: isObscure,
                    ));
                  },
                ),
                const SizedBox(height: 32),
                TextField(
                  autofillHints: const ['password'],
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    hintText: confirmHint,
                    suffixIcon: showObscureIcon
                        ? GestureDetector(
                            onTap: () {
                              field.didChange(_PasswordPair(
                                pass: pass,
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
                  onChanged: (String value) {
                    field.didChange(_PasswordPair(
                      pass: pass,
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
