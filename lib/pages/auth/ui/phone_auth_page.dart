import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/features/auth/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран авторизации. Переключает формы между шагами.
class PhoneAuthPage extends ConsumerWidget {
  const PhoneAuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final step = ref.watch(phoneAuthStepProvider);

    // Держим провайдер «живым», пока открыт экран.
    // Без этой строки autoDispose сбросит номер при переходе phone → otp,
    // и OtpStepForm увидит пустое значение.
    ref.watch(phoneAuthNumberProvider);
    ref.watch(phoneVerificationChallengeProvider);

    // Один слушатель ошибок на всю страницу.
    // Формы внутри (PhoneStepForm, OtpStepForm) НЕ должны его вызывать.
    useAuthErrorListener(context, ref);

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/'),
        title: Text(l.phoneAuthTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: switch (step) {
          PhoneAuthStep.phone => const PhoneStepForm(),
          PhoneAuthStep.telegram => const TelegramVerificationForm(),
          PhoneAuthStep.otp => const OtpStepForm(),
        },
      ),
    );
  }
}
