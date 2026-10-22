import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ecommerce_new/shared/ui/inputs/app_text_field.dart';

/// Поле пароля с кнопкой «показать/скрыть».
/// Используется во всех формах, где вводится пароль.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.formControlName = 'password',
    this.labelText,
    this.textInputAction = TextInputAction.done,
  });

  final String formControlName;
  final String? labelText;
  final TextInputAction? textInputAction;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppTextField(
      formControlName: widget.formControlName,
      labelText: widget.labelText ?? l.passwordLabel,
      obscureText: _obscure,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      autofillHints: const [AutofillHints.password],
      textInputAction: widget.textInputAction,
      validationMessages: {
        ValidationMessage.minLength: (_) => l.passwordTooShort,
      },
    );
  }
}
