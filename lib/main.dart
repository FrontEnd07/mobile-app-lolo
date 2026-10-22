import 'package:ecommerce_new/entities/auth/index.dart';
import 'package:ecommerce_new/app/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_new/app/app.dart';
import 'package:ecommerce_new/features/auth/index.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/shared/api/vendure_client.dart';
import 'package:ecommerce_new/shared/storage/settings_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final settingsStorage = SettingsStorage(prefs);
  final container = ProviderContainer(
    overrides: [
      ...appProviderOverrides,
      settingsStorageProvider.overrideWithValue(settingsStorage),
    ],
  );
  final savedToken = await container.read(authStorageProvider).readToken();
  if (savedToken != null && savedToken.isNotEmpty) {
    await VendureClient.initialize(
      languageCode: settingsStorage.language,
      token: savedToken,
    );
  } else {
    await VendureClient.initialize(languageCode: settingsStorage.language);
  }

  await container.read(authProvider.notifier).initialize();

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
