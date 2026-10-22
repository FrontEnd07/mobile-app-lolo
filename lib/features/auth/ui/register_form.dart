import 'package:ecommerce_new/features/auth/lib/use_auth_error_listener.dart';
import 'package:ecommerce_new/features/auth/model/auth_provider.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/buttons/loading_button.dart';
import 'package:ecommerce_new/shared/ui/inputs/app_text_field.dart';
import 'package:ecommerce_new/shared/ui/inputs/email_field.dart';
import 'package:ecommerce_new/shared/ui/inputs/password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Форма регистрации.
class RegisterForm extends ConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    final form = FormGroup({
      'firstName': FormControl<String>(),
      'lastName': FormControl<String>(),
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)],
      ),
    });

    useAuthErrorListener(context, ref);

    return ReactiveForm(
      formGroup: form,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.registerTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // ↓ Используем базовый AppTextField для имени/фамилии
            AppTextField(
              formControlName: 'firstName',
              labelText: l.firstNameLabel,
              prefixIcon: const Icon(Icons.person_outline),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            AppTextField(
              formControlName: 'lastName',
              labelText: l.lastNameLabel,
              prefixIcon: const Icon(Icons.person_outline),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // ↓ Переиспользуемые EmailField и PasswordField
            const EmailField(),
            const SizedBox(height: 16),
            const PasswordField(textInputAction: TextInputAction.done),
            const SizedBox(height: 24),

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
                          .register(
                            email: form.control('email').value as String,
                            password: form.control('password').value as String,
                            firstName:
                                form.control('firstName').value as String?,
                            lastName: form.control('lastName').value as String?,
                          );
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                  child: Text(l.registerButton),
                );
              },
            ),
            const SizedBox(height: 16),

            TextButton(
              onPressed: () => context.goNamed('login'),
              child: Text(l.alreadyHaveAccountPrompt),
            ),
          ],
        ),
      ),
    );
  }
}
