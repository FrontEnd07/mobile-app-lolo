import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendure/vendure.dart';
import 'package:ecommerce_new/shared/api/vendure_client.dart';
import 'package:ecommerce_new/entities/auth/index.dart';
import 'package:ecommerce_new/features/auth/api/phone_auth_repository.dart';
import 'package:ecommerce_new/features/auth/model/phone_auth_flow.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._storage) : super(const AuthState());

  final AuthStorage _storage;
  final _phoneAuth = PhoneAuthRepository();

  Future<void> initialize() async {
    final token = await _storage.readToken();

    if (token == null || token.isEmpty) {
      state = state.copyWith(isInitialized: true);
      return;
    }

    try {
      await VendureClient.setAuthToken(token);
      final customer = await VendureClient.instance.customer
          .getActiveCustomer();

      if (customer == null) {
        await _storage.clearToken();
        state = state.copyWith(isInitialized: true);
        return;
      }

      state = state.copyWith(user: _mapCustomer(customer), isInitialized: true);
    } catch (_) {
      state = state.copyWith(isInitialized: true, error: 'authErrorNetwork');
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await VendureClient.instance.auth.login(
        username: email,
        password: password,
        rememberMe: true,
      );

      final json = result.toJson();

      if (json.containsKey('id') && json.containsKey('identifier')) {
        String? token;
        try {
          token = await VendureClient.instance.auth.getToken(
            username: email,
            password: password,
          );
        } catch (_) {}

        if (token != null && token.isNotEmpty) {
          await _storage.saveToken(token);
          await VendureClient.setAuthToken(token);
        }

        state = state.copyWith(
          user: AuthUser(
            id: (json['id'] as String?) ?? '',
            email: (json['identifier'] as String?) ?? '',
          ),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: (json['message'] as String?) ?? 'authErrorInvalidCredentials',
        );
      }
    } catch (e) {
      final message = e.toString().toLowerCase();
      final errorKey = message.contains('invalid credentials')
          ? 'authErrorInvalidCredentials'
          : message.contains('not verified')
          ? 'authErrorNotVerified'
          : 'authErrorNetwork';
      state = state.copyWith(isLoading: false, error: errorKey);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await VendureClient.instance.auth.registerCustomerAccount(
        input: RegisterCustomerInput(
          emailAddress: email,
          firstName: firstName,
          lastName: lastName,
          password: password,
        ),
      );

      final json = result.toJson();

      if (json['success'] != true) {
        state = state.copyWith(
          isLoading: false,
          error:
              (json['message'] as String?) ??
              (json['validationErrorMessage'] as String?) ??
              'authErrorRegistrationFailed',
        );
        return;
      }

      await login(email: email, password: password);

      if (!state.isAuthenticated &&
          state.error == 'authErrorInvalidCredentials') {
        state = state.copyWith(error: 'authErrorEmailTaken');
      }
    } catch (e) {
      final message = e.toString().toLowerCase();
      final errorKey = message.contains('email')
          ? 'authErrorEmailTaken'
          : message.contains('password')
          ? 'authErrorPasswordValidation'
          : 'authErrorRegistrationFailed';
      state = state.copyWith(isLoading: false, error: errorKey);
    }
  }

  Future<PhoneVerificationChallenge> requestOtp({
    required String phoneNumber,
    required VerificationMethod method,
    required String locale,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final challenge = await _phoneAuth.requestVerification(
        phoneNumber: phoneNumber,
        method: method,
        locale: locale,
      );
      state = state.copyWith(isLoading: false);
      return challenge;
    } catch (e) {
      final key =
          e is PhoneAuthException &&
              e.errorCode == 'PHONE_NUMBER_VALIDATION_ERROR'
          ? 'authErrorInvalidPhone'
          : 'authErrorNetwork';
      state = state.copyWith(isLoading: false, error: key);
      rethrow;
    }
  }

  Future<bool> isTelegramMessageReceived(String challengeId) =>
      _phoneAuth.isTelegramMessageReceived(challengeId);

  /// Проверяет OTP-код и логинит пользователя.
  Future<void> verifyOtp({
    required String challengeId,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _phoneAuth.verifyOtp(
        challengeId: challengeId,
        code: code,
      );

      // Токен, перехваченный из заголовка Vendure-Auth-Token.
      final token = _phoneAuth.capturedToken;
      if (token != null && token.isNotEmpty) {
        await _storage.saveToken(token);
        await VendureClient.setAuthToken(token);
      }

      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      final message = e.toString().toLowerCase();
      final key =
          message.contains('verification code') ||
              message.contains('invalid code')
          ? 'authErrorInvalidOtp'
          : 'authErrorNetwork';
      state = state.copyWith(isLoading: false, error: key);
    }
  }

  Future<void> logout() async {
    try {
      await VendureClient.instance.auth.logout();
    } catch (_) {}
    await _storage.clearToken();
    VendureClient.clearAuthToken();
    state = const AuthState(isInitialized: true);
  }

  void updateProfileNames(String firstName, String lastName) {
    final user = state.user;
    if (user == null) return;
    state = state.copyWith(
      user: AuthUser(
        id: user.id,
        email: user.email,
        firstName: firstName,
        lastName: lastName,
      ),
    );
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(clearError: true);
    }
  }

  AuthUser _mapCustomer(Customer? customer) {
    return AuthUser(
      id: customer?.id ?? '',
      email: customer?.emailAddress ?? '',
      firstName: customer?.firstName,
      lastName: customer?.lastName,
    );
  }
}
