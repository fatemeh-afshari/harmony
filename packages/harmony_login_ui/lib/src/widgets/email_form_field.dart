import 'package:flutter/material.dart';

class LoginUIEmailFromField extends FormField<String> {
  static const _pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static String? _validator(String email) {
    final match = RegExp(_pattern).matchAsPrefix(email);
    if (match != null && match.end == email.length) {
      return null;
    } else {
      return 'Invalid email address';
    }
  }

  LoginUIEmailFromField({
    final Key? key,
    final String? Function(String email)? validator = _validator,
    final void Function(String email)? onSaved,
    final void Function()? onSubmit,
    final bool hasNext = true,
    final bool enabled = true,
    final String? emailHint = 'Email',
  }) : super(
          key: key,
          enabled: enabled,
          validator: (String? value) {
            return validator?.call(value!);
          },
          onSaved: (String? value) {
            onSaved?.call(value!);
          },
          initialValue: '',
          builder: (field) {
            final error = field.errorText;
            return TextField(
              autofillHints: const ['email'],
              enabled: enabled,
              textInputAction:
                  hasNext ? TextInputAction.next : TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: emailHint,
                errorText: error,
              ),
              onSubmitted: (value) {
                onSubmit?.call();
              },
              onChanged: (value) {
                field.didChange(value.trim());
              },
            );
          },
        );
}
