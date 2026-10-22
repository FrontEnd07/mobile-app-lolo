import 'package:ecommerce_new/features/auth/model/auth_provider.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/buttons/loading_button.dart';
import 'package:ecommerce_new/shared/ui/inputs/otp_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/features/auth/model/phone_auth_flow.dart';

/// Второй шаг авторизации — ввод OTP-кода.
class OtpStepForm extends ConsumerStatefulWidget {
  const OtpStepForm({super.key});

  @override
  ConsumerState<OtpStepForm> createState() => _OtpStepFormState();
}

class _OtpStepFormState extends ConsumerState<OtpStepForm> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();
    if (code.length != 6 || ref.read(authProvider).isLoading) return;

    final challenge = ref.read(phoneVerificationChallengeProvider);
    if (challenge == null) return;
    await ref
        .read(authProvider.notifier)
        .verifyOtp(challengeId: challenge.id, code: code);
  }

  void _goBackToPhone() {
    _otpController.clear();
    ref.read(phoneVerificationChallengeProvider.notifier).state = null;
    ref.read(phoneAuthStepProvider.notifier).state = PhoneAuthStep.phone;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isLoading = ref.watch(authProvider.select((s) => s.isLoading));
    final phone = ref.watch(phoneAuthNumberProvider);
    final method = ref.watch(verificationMethodProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          l.otpTitle,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          method == VerificationMethod.whatsapp
              ? l.otpSubtitleWhatsApp(phone)
              : l.otpSubtitleTelegram,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        OtpField(
          controller: _otpController,
          enabled: !isLoading,
          onCompleted: (_) => _verifyOtp(),
        ),
        const SizedBox(height: 24),
        LoadingButton(
          isLoading: isLoading,
          onPressed: _verifyOtp,
          child: Text(l.verifyOtpButton),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: isLoading ? null : _goBackToPhone,
          child: Text(l.changePhoneButton),
        ),
      ],
    );
  }
}
