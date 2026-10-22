import 'package:ecommerce_new/shared/i18n/app_localizations.dart';

/// Переводит строковый ключ ошибки (например, 'authErrorNetwork')
/// в локализованный текст. Если ключ не найден — вернёт как есть.
String localizeError(AppLocalizations l, String key) {
  return switch (key) {
    'authErrorInvalidCredentials' => l.authErrorInvalidCredentials,
    'authErrorNetwork' => l.authErrorNetwork,
    'authErrorRegistrationFailed' => l.authErrorRegistrationFailed,
    'authErrorNativeStrategy' => l.authErrorNativeStrategy,
    'authErrorNotVerified' => l.authErrorNotVerified,
    'authErrorMissingPassword' => l.authErrorMissingPassword,
    'authErrorPasswordValidation' => l.authErrorPasswordValidation,
    'authErrorEmailTaken' => l.authErrorEmailTaken,
    'authErrorInvalidPhone' => l.authErrorInvalidPhone,
    'authErrorInvalidOtp' => l.authErrorInvalidOtp,
    _ => key,
  };
}
