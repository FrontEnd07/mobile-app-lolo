import 'package:flutter/foundation.dart';

/// Модель авторизованного пользователя.
/// Соответствует `Customer` в Vendure, но содержит только то,
/// что нужно UI: id, email, имя, фамилия.
@immutable
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
  });

  final String id;
  final String email;
  final String? firstName;
  final String? lastName;

  /// Полное имя для отображения. Используется во всех местах:
  /// в профиле, в AppBar, в приветствии, в отзывах.
  String get displayName {
    final parts = [firstName, lastName].whereType<String>().toList();
    if (parts.isEmpty) return email;
    return parts.join(' ');
  }

  /// Инициал для аватара.
  String get initial {
    final name = displayName.trim();
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          other.id == id &&
          other.email == email &&
          other.firstName == firstName &&
          other.lastName == lastName;

  @override
  int get hashCode => Object.hash(id, email, firstName, lastName);
}
