import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/features/auth/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/'),
        title: Text(l.loginTitle),
      ),
      body: const SingleChildScrollView(child: LoginForm()),
    );
  }
}
