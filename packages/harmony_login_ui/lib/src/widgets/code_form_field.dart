import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginUICodeFormField extends FormField<List<String>> {
  final int count;

  LoginUICodeFormField({
    this.count = 4,
    final void Function(String code)? onSaved,
    final void Function()? onSubmit,
    final bool enabled = true,
  }) : super(
          initialValue: List.filled(count, '', growable: false),
          enabled: enabled,
          validator: (List<String>? value) {
            assert((() => value!.length == count)());
            if (value!.every((e) => e.isNotEmpty)) {
              if (value
                  .map((e) => int.tryParse(e))
                  .every((e) => e != null && (e >= 0 && e < 10))) {
                return null;
              }
            }
            return 'Code is invalid';
          },
          onSaved: (List<String>? value) {
            if (onSaved != null) {
              onSaved(value!.join());
            }
          },
          builder: (field) {
            final list = field.value!;
            // final error = field.errorText;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(2 * count - 1, (index) {
                if (index % 2 == 0) {
                  final pos = index ~/ 2;
                  final isLast = pos == count - 1;
                  return SizedBox(
                    width: 32,
                    child: TextField(
                      key: Key('code-$pos'),
                      controller: TextEditingController(),
                      onSubmitted: (value) {
                        if (isLast) {
                          FocusScope.of(field.context).unfocus();
                          onSubmit?.call();
                        } else {
                          FocusScope.of(field.context).nextFocus();
                        }
                      },
                      textInputAction:
                          isLast ? TextInputAction.done : TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: false,
                      ),
                      enabled: enabled,
                      autocorrect: false,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value) {
                        // update in-place since we don't expose list
                        list[pos] = value;
                        field.didChange(list);
                        if (value.isNotEmpty) {
                          if (isLast) {
                            FocusScope.of(field.context).unfocus();
                            onSubmit?.call();
                          } else {
                            FocusScope.of(field.context).nextFocus();
                          }
                        }
                      },
                    ),
                  );
                } else {
                  return const SizedBox(width: 16);
                }
              }),
            );
          },
        );

  @override
  FormFieldState<List<String>> createState() => _LoginUICodeFormFieldState();
}

class _LoginUICodeFormFieldState extends FormFieldState<List<String>> {
  @override
  void didUpdateWidget(covariant FormField<List<String>> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final w = widget as LoginUICodeFormField;
    final ow = oldWidget as LoginUICodeFormField;
    if (w.count != ow.count) {
      reset();
    }
  }
}
