import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';

/// Базовое текстовое поле с единым стилем и обработкой ошибок.
/// Все остальные поля (Email, Password, Phone) построены на нём.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.formControlName,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.validationMessages,
    this.textInputAction,
    this.maxLines = 1,
  });

  final String formControlName;
  final String labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final Map<String, String Function(Object)>? validationMessages;
  final TextInputAction? textInputAction;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ReactiveTextField<String>(
      formControlName: formControlName,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      maxLines: obscureText ? 1 : maxLines,
      validationMessages: {
        ValidationMessage.required: (_) => l.fieldRequired,
        ...?validationMessages,
      },
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
