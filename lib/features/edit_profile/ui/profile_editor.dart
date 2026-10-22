import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

class ProfileEditor extends ConsumerStatefulWidget {
  const ProfileEditor({
    super.key,
    required this.customer,
    required this.onSaved,
  });
  final Json customer;
  final ValueChanged<Json> onSaved;
  @override
  ConsumerState<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends ConsumerState<ProfileEditor> {
  final form = GlobalKey<FormState>();
  final first = TextEditingController(), last = TextEditingController();
  bool busy = false;
  @override
  void initState() {
    super.initState();
    first.text = widget.customer['firstName'] as String? ?? '';
    last.text = widget.customer['lastName'] as String? ?? '';
  }

  @override
  void dispose() {
    first.dispose();
    last.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final l = AppLocalizations.of(context);
    if (busy || !(form.currentState?.validate() ?? false)) return;
    setState(() => busy = true);
    final repository = ref.read(customerRepositoryProvider);
    try {
      final updated = await repository.updateNames(first.text, last.text);
      if (!mounted ||
          !identical(repository, ref.read(customerRepositoryProvider))) {
        return;
      }
      widget.onSaved(updated);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.profileSaved)));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.profileSaveError)));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Form(
      key: form,
      child: Column(
        children: [
          TextFormField(
            controller: first,
            enabled: !busy,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l.firstNameLabel),
            validator: (value) => value == null || value.trim().isEmpty
                ? l.profileNameRequired
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: last,
            enabled: !busy,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l.lastNameLabel),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: busy ? null : save,
            child: Text(l.commonSave),
          ),
        ],
      ),
    );
  }
}
