/// Общие константы приложения.
class AppConstants {
  AppConstants._();

  // Ключи хранилища (SharedPreferences)
  static const String keyLanguage = 'app_language';
  static const String keyCurrency = 'app_currency';
  static const String keyTheme = 'app_theme_mode';
  static const String keyOnboardingDone = 'app_onboarding_done';

  // Дефолтные значения
  static const String defaultLanguage = 'ru';
  static const String defaultCurrency = 'TJS';

  // Поддерживаемые языки
  static const List<String> supportedLanguages = ['ru', 'tg', 'en'];

  // Поддерживаемые валюты
  static const List<String> supportedCurrencies = ['TJS', 'USD', 'RUB'];

  // Пагинация
  static const int productsPerPage = 20;
}
