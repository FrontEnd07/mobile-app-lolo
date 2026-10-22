import 'dart:async';

import 'package:ecommerce_new/features/auth/model/auth_provider.dart';
import 'package:ecommerce_new/features/auth/model/phone_auth_flow.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class TelegramVerificationForm extends ConsumerStatefulWidget {
  const TelegramVerificationForm({super.key});

  @override
  ConsumerState<TelegramVerificationForm> createState() =>
      _TelegramVerificationFormState();
}

class _TelegramVerificationFormState
    extends ConsumerState<TelegramVerificationForm> {
  Timer? _timer;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _checkStatus());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    if (_checking) return;
    final challenge = ref.read(phoneVerificationChallengeProvider);
    if (challenge == null) return;
    _checking = true;
    try {
      final received = await ref
          .read(authProvider.notifier)
          .isTelegramMessageReceived(challenge.id);
      if (received && mounted) {
        _timer?.cancel();
        ref.read(phoneAuthStepProvider.notifier).state = PhoneAuthStep.otp;
      }
    } catch (_) {
      // A temporary network error should not reset the verification flow.
    } finally {
      _checking = false;
    }
  }

  Future<void> _openTelegram() async {
    final url = ref.read(phoneVerificationChallengeProvider)?.telegramUrl;
    if (url == null) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _goBack() {
    ref.read(phoneVerificationChallengeProvider.notifier).state = null;
    ref.read(phoneAuthStepProvider.notifier).state = PhoneAuthStep.phone;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        const Icon(Icons.send_rounded, size: 56),
        const SizedBox(height: 20),
        Text(
          l.telegramVerificationTitle,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(l.telegramVerificationDescription, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _openTelegram,
          icon: const Icon(Icons.open_in_new),
          label: Text(l.openTelegramButton),
        ),
        const SizedBox(height: 20),
        const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 8),
        Text(l.telegramWaitingMessage, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        TextButton(onPressed: _goBack, child: Text(l.changePhoneButton)),
      ],
    );
  }
}
