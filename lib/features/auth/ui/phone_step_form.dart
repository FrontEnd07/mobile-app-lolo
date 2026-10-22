import 'package:ecommerce_new/features/auth/model/auth_provider.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/buttons/loading_button.dart';
import 'package:ecommerce_new/shared/ui/inputs/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/features/auth/model/phone_auth_flow.dart';

/// Первый шаг авторизации — ввод номера телефона и запрос OTP.
class PhoneStepForm extends ConsumerStatefulWidget {
  const PhoneStepForm({super.key});

  @override
  ConsumerState<PhoneStepForm> createState() => _PhoneStepFormState();
}

class _PhoneStepFormState extends ConsumerState<PhoneStepForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.TJ, nsn: ''),
  );

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (ref.read(authProvider).isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = _phoneController.value.international;
    final method = ref.read(verificationMethodProvider);
    final locale = Localizations.localeOf(context).languageCode;

    try {
      final challenge = await ref
          .read(authProvider.notifier)
          .requestOtp(phoneNumber: phone, method: method, locale: locale);
      if (!mounted) return;

      ref.read(phoneAuthNumberProvider.notifier).state = phone;
      ref.read(phoneVerificationChallengeProvider.notifier).state = challenge;
      ref
          .read(phoneAuthStepProvider.notifier)
          .state = method == VerificationMethod.telegram
          ? PhoneAuthStep.telegram
          : PhoneAuthStep.otp;
    } catch (_) {
      // Ошибка показывается через useAuthErrorListener.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isLoading = ref.watch(authProvider.select((s) => s.isLoading));
    final method = ref.watch(verificationMethodProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          PhoneField(
            controller: _phoneController,
            autofocus: true,
            enabled: !isLoading,
            onSubmitted: (_) => _sendOtp(),
          ),
          const SizedBox(height: 20),
          Text(l.verificationMethodTitle),
          const SizedBox(height: 8),
          SegmentedButton<VerificationMethod>(
            segments: [
              ButtonSegment(
                value: VerificationMethod.whatsapp,
                icon: const Icon(Icons.chat_outlined),
                label: Text(l.verificationWhatsApp),
              ),
              ButtonSegment(
                value: VerificationMethod.telegram,
                icon: const Icon(Icons.send_outlined),
                label: Text(l.verificationTelegram),
              ),
            ],
            selected: {method},
            onSelectionChanged: isLoading
                ? null
                : (selection) =>
                      ref.read(verificationMethodProvider.notifier).state =
                          selection.first,
          ),
          const SizedBox(height: 24),
          LoadingButton(
            isLoading: isLoading,
            onPressed: _sendOtp,
            child: Text(l.sendOtpButton),
          ),
        ],
      ),
    );
  }
}
