import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';

/// Переиспользуемое поле для ввода OTP-кода.
/// Крупные цифры, центрирование, 6 знаков.
/// Используется для входа, подтверждения операций, 2FA.
class OtpField extends StatelessWidget {
  const OtpField({
    super.key,
    required this.controller,
    this.length = 6,
    this.autofocus = true,
    this.onCompleted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final int length;
  final bool autofocus;
  final ValueChanged<String>? onCompleted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: length,
      style: const TextStyle(fontSize: 24, letterSpacing: 8),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: l.otpLabel, counterText: ''),
      onChanged: (value) {
        if (value.length == length) {
          onCompleted?.call(value);
        }
      },
    );
  }
}
