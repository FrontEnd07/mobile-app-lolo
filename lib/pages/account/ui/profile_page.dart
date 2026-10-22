import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:ecommerce_new/features/auth/index.dart';
import 'package:ecommerce_new/features/edit_profile/index.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    Future<void> logout() async {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) context.go('/');
    }

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/'),
        title: Text(l.navProfile),
      ),
      body: AsyncContent(
        value: ref.watch(customerProfileProvider),
        onRetry: () => ref.invalidate(customerProfileProvider),
        builder: (customer) {
          if (customer == null) {
            return Center(
              child: TextButton(
                onPressed: logout,
                child: Text(l.sessionExpiredSignOut),
              ),
            );
          }
          final email = customer['emailAddress'] as String;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(Icons.account_circle_outlined, size: 72),
              const SizedBox(height: 20),
              if ((customer['phoneNumber'] as String?)?.isNotEmpty == true)
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(customer['phoneNumber'] as String),
                ),
              if (!isGeneratedPhoneEmail(email))
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: Text(email),
                ),
              ProfileEditor(
                key: ValueKey(customer['id']),
                customer: customer,
                onSaved: (updated) => ref
                    .read(authProvider.notifier)
                    .updateProfileNames(
                      updated['firstName'] as String,
                      updated['lastName'] as String,
                    ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(l.addressesTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/addresses'),
              ),

              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text(l.ordersTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/orders'),
              ),
              ListTile(
                leading: const Icon(Icons.tune),
                title: Text(l.settingsTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings'),
              ),
              TextButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: Text(l.commonSignOut),
              ),
            ],
          );
        },
      ),
    );
  }
}
