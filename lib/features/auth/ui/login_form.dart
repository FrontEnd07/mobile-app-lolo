import 'package:ecommerce_new/features/auth/lib/use_auth_error_listener.dart';
import 'package:ecommerce_new/features/auth/model/auth_provider.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/buttons/loading_button.dart';
import 'package:ecommerce_new/shared/ui/inputs/email_field.dart';
import 'package:ecommerce_new/shared/ui/inputs/password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Форма входа в аккаунт.
/// Вся бизнес-логика лежит в AuthNotifier — этот виджет только UI.
class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    final form = FormGroup({
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)],
      ),
    });

    // Переиспользуемый хук — показывает ошибки auth через SnackBar
    useAuthErrorListener(context, ref);

    return ReactiveForm(
      formGroup: form,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.loginTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // ↓ Переиспользуемые компоненты из shared/ui
            const EmailField(),
            const SizedBox(height: 16),
            const PasswordField(textInputAction: TextInputAction.done),
            const SizedBox(height: 24),

            // ↓ Кнопка с индикатором загрузки
            Consumer(
              builder: (context, ref, _) {
                final isLoading = ref.watch(
                  authProvider.select((s) => s.isLoading),
                );
                return LoadingButton(
                  isLoading: isLoading,
                  onPressed: () {
                    if (form.valid) {
                      ref
                          .read(authProvider.notifier)
                          .login(
                            email: form.control('email').value as String,
                            password: form.control('password').value as String,
                          );
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                  child: Text(l.loginButton),
                );
              },
            ),
            const SizedBox(height: 16),

            // ↓ Ссылка на регистрацию
            TextButton(
              onPressed: () => context.goNamed('register'),
              child: Text(l.noAccountPrompt),
            ),
          ],
        ),
      ),
    );
  }
}
