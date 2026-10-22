/// Переменные окружения и конфигурация API.
/// ВАЖНО: все URL-адреса только здесь — никакого хардкода в других файлах.
class Env {
  Env._();

  /// Точка входа Shop API Vendure.
  /// Для эмулятора Android localhost хоста доступен через 10.0.2.2.
  /// Для продакшена заменить на реальный домен.
  static const String vendureEndpoint = String.fromEnvironment(
    'VENDURE_API_URL',
    defaultValue: 'http://10.0.2.2:3000/shop-api',
  );

  /// Токен канала Vendure.
  static const String channelToken = String.fromEnvironment(
    'VENDURE_CHANNEL_TOKEN',
    defaultValue: '__default_channel__',
  );

  /// Доступные каналы (для мультивендорности в будущем).
  static const String defaultChannel = '__default_channel__';

  /// Таймаут сетевых запросов в секундах.
  static const int requestTimeoutSeconds = 30;
}
