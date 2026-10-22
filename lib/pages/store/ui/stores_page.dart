import 'package:ecommerce_new/entities/store/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';
import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoresPage extends ConsumerWidget {
  const StoresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/'),
        title: Text(l.storesTitle),
      ),
      body: ref
          .watch(storesProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => RetryView(
              message: l.storesLoadError,
              onRetry: () => ref.invalidate(storesProvider),
            ),
            data: (result) {
              final stores = List<Json>.from(result['items']);
              final entries = [
                for (final store in stores)
                  for (final channel in List<Json>.from(store['channels']))
                    {'store': store, 'channel': channel},
              ];
              if (entries.isEmpty) return Center(child: Text(l.storesEmpty));
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(storesProvider);
                  await ref.read(storesProvider.future);
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final store = entries[index]['store'] as Json;
                    final channel = entries[index]['channel'] as Json;
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.storefront_outlined),
                        ),
                        title: Text(store['name'] as String),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(
                          '/store/${Uri.encodeComponent(channel['token'] as String)}',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
    );
  }
}
