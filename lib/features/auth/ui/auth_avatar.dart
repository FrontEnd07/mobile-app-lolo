import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/features/auth/model/auth_provider.dart';

/// Виджет в правом углу AppBar. Показывает либо кнопку «Войти»,
/// либо аватар с меню (Профиль / Выход).
/// Переиспользуется на всех страницах: главная, каталог, корзина, заказы.
class AuthAvatar extends ConsumerWidget {
  const AuthAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final l = AppLocalizations.of(context);

    if (!auth.isAuthenticated) {
      return IconButton(
        icon: const Icon(Icons.person_outline),
        tooltip: l.loginTitle,
        onPressed: () => context.goNamed('login'),
      );
    }

    final user = auth.user!;
    return PopupMenuButton<String>(
      tooltip: user.displayName,
      onSelected: (value) {
        switch (value) {
          case 'profile':
            context.pushNamed('profile');
          case 'logout':
            ref.read(authProvider.notifier).logout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'profile', child: Text(l.profileLabel)),
        PopupMenuItem(value: 'logout', child: Text(l.logoutLabel)),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CircleAvatar(radius: 16, child: Text(user.initial)),
      ),
    );
  }
}
