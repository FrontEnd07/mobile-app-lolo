import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Шаг сценария «вход по телефону».
enum PhoneAuthStep { phone, telegram, otp }

enum VerificationMethod { whatsapp, telegram }

class PhoneVerificationChallenge {
  const PhoneVerificationChallenge({
    required this.id,
    required this.method,
    this.telegramUrl,
  });

  final String id;
  final VerificationMethod method;
  final String? telegramUrl;
}

/// Хранит текущий шаг: ввод телефона или ввод OTP.
/// Сбрасывается при уходе с экрана.
final phoneAuthStepProvider = StateProvider.autoDispose<PhoneAuthStep>(
  (ref) => PhoneAuthStep.phone,
);

/// Номер телефона, на который был отправлен код.
/// Нужен для шага OTP — чтобы отправить его на бэкенд при верификации.
final phoneAuthNumberProvider = StateProvider.autoDispose<String>((ref) => '');

final verificationMethodProvider =
    StateProvider.autoDispose<VerificationMethod>(
      (ref) => VerificationMethod.whatsapp,
    );

final phoneVerificationChallengeProvider =
    StateProvider.autoDispose<PhoneVerificationChallenge?>((ref) => null);
