import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/features/auth/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/'),
        title: Text(l.registerTitle),
      ),
      body: const SingleChildScrollView(child: RegisterForm()),
    );
  }
}
