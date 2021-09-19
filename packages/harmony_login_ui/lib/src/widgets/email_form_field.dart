import 'package:flutter/material.dart';

class EmailFromField extends FormField<String> {
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

  EmailFromField({
    Key? key,
    String? Function(String email)? validator = _validator,
    void Function(String email)? onSaved,
    String? emailHint = 'Email',
  }) : super(
          key: key,
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
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: emailHint,
                errorText: error,
              ),
              onChanged: (String value) {
                field.didChange(value.trim());
              },
            );
          },
        );
}
