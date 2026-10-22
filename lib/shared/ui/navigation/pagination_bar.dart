import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({
    super.key,
    required this.offset,
    required this.count,
    required this.total,
    required this.pageSize,
    required this.onChanged,
  });
  final int offset, count, total, pageSize;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: offset > 0 ? () => onChanged(offset - pageSize) : null,
          child: Text(l.commonPrevious),
        ),
        Text('${count == 0 ? 0 : offset + 1}–${offset + count} / $total'),
        TextButton(
          onPressed: offset + count < total
              ? () => onChanged(offset + pageSize)
              : null,
          child: Text(l.commonNext),
        ),
      ],
    );
  }
}
