import 'package:flutter/material.dart';

/// Кнопка с индикатором загрузки. Блокируется, пока идёт операция.
/// Используется во всех местах, где есть async-действие:
/// вход, регистрация, оформление заказа, отправка формы, лайк.
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.icon,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return FilledButton(
        onPressed: null,
        child: const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return icon != null
        ? FilledButton.icon(onPressed: onPressed, icon: icon!, label: child)
        : FilledButton(onPressed: onPressed, child: child);
  }
}
