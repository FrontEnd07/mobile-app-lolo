import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/features/auth/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final channelCurrencies = ref.watch(channelCurrenciesProvider);
    ref.listen(channelCurrenciesProvider, (_, next) {
      next.whenData((currencies) {
        final selected = ref.read(settingsProvider).currencyCode;
        if (currencies.isNotEmpty && !currencies.contains(selected)) {
          notifier.setCurrency(currencies.first);
        }
      });
    });
    final isAuthenticated = ref.watch(
      authProvider.select((state) => state.isAuthenticated),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/'),
        title: Text(l.settingsTitle),
        actions: const [AuthAvatar()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.homeWelcome, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          Text(
            l.homeCurrentSettings,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          // Язык
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l.settingsLanguage),
            subtitle: Text(_languageName(settings.locale.languageCode, l)),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.arrow_drop_down),
              onSelected: notifier.setLanguage,
              itemBuilder: (_) => [
                PopupMenuItem(value: 'ru', child: Text(l.languageRu)),
                PopupMenuItem(value: 'tg', child: Text(l.languageTg)),
                PopupMenuItem(value: 'en', child: Text(l.languageEn)),
              ],
            ),
          ),

          // Валюта
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: Text(l.settingsCurrency),
            subtitle: Text(settings.currencyCode),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.arrow_drop_down),
              onSelected: notifier.setCurrency,
              itemBuilder: (_) => channelCurrencies.maybeWhen(
                data: (currencies) => currencies
                    .map(
                      (code) => PopupMenuItem(
                        value: code,
                        child: Text(_currencyName(code, l)),
                      ),
                    )
                    .toList(),
                orElse: () => [
                  PopupMenuItem(
                    value: settings.currencyCode,
                    child: Text(_currencyName(settings.currencyCode, l)),
                  ),
                ],
              ),
            ),
          ),

          // Тема
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l.settingsTheme),
            subtitle: Text(_themeName(settings.themeMode, l)),
            trailing: PopupMenuButton<ThemeMode>(
              icon: const Icon(Icons.arrow_drop_down),
              onSelected: notifier.setThemeMode,
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: ThemeMode.light,
                  child: Text(l.themeLight),
                ),
                PopupMenuItem(value: ThemeMode.dark, child: Text(l.themeDark)),
                PopupMenuItem(
                  value: ThemeMode.system,
                  child: Text(l.themeSystem),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l.privacyPolicy),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _openPrivacyPolicy(context, l),
          ),
          if (isAuthenticated)
            ListTile(
              leading: Icon(
                Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                l.deleteAccount,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              subtitle: Text(l.deleteAccountSubtitle),
              onTap: () => _requestAccountDeletion(context, ref, l),
            ),
        ],
      ),
    );
  }

  Future<void> _requestAccountDeletion(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteAccount),
        content: Text(l.deleteAccountConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.deleteAccountRequest),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref
          .read(customerRepositoryProvider)
          .requestAccountDeletion(Localizations.localeOf(context).languageCode);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.deleteAccountRequestReceived)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.deleteAccountRequestError)));
      }
    }
  }

  Future<void> _openPrivacyPolicy(
    BuildContext context,
    AppLocalizations l,
  ) async {
    final opened = await launchUrl(
      Uri.parse('https://lolo.tj/privacy'),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.linkOpenError)));
    }
  }

  String _languageName(String code, AppLocalizations l) => switch (code) {
    'ru' => l.languageRu,
    'tg' => l.languageTg,
    'en' => l.languageEn,
    _ => code,
  };

  String _themeName(ThemeMode mode, AppLocalizations l) => switch (mode) {
    ThemeMode.light => l.themeLight,
    ThemeMode.dark => l.themeDark,
    ThemeMode.system => l.themeSystem,
  };

  String _currencyName(String code, AppLocalizations l) => switch (code) {
    'TJS' => l.currencyTjs,
    'USD' => l.currencyUsd,
    'RUB' => l.currencyRub,
    _ => code,
  };
}
