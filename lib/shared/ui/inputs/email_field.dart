import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ecommerce_new/shared/ui/inputs/app_text_field.dart';

/// Поле для ввода email. Используется во всех формах,
/// где нужен email: вход, регистрация, восстановление пароля,
/// оформление заказа, профиль.
class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    this.formControlName = 'email',
    this.labelText,
    this.textInputAction = TextInputAction.next,
  });

  final String formControlName;
  final String? labelText;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppTextField(
      formControlName: formControlName,
      labelText: labelText ?? l.emailLabel,
      prefixIcon: const Icon(Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: textInputAction,
      validationMessages: {ValidationMessage.email: (_) => l.fieldInvalidEmail},
    );
  }
}
