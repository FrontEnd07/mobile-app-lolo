import 'package:flutter/foundation.dart';
import 'package:ecommerce_new/entities/auth/model/auth_user.dart';

/// Состояние авторизации.
@immutable
class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isInitialized = false,
  });

  final AuthUser? user;
  final bool isLoading;
  final String? error;

  /// Стал ли `initialize()` завершён. Нужно для splash screen.
  final bool isInitialized;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AuthUser? user,
    bool? isLoading,
    String? error,
    bool? isInitialized,
    bool clearUser = false,
    bool clearError = false,
  }) => AuthState(
    user: clearUser ? null : (user ?? this.user),
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : (error ?? this.error),
    isInitialized: isInitialized ?? this.isInitialized,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          other.user == user &&
          other.isLoading == isLoading &&
          other.error == error &&
          other.isInitialized == isInitialized;

  @override
  int get hashCode => Object.hash(user, isLoading, error, isInitialized);
}
