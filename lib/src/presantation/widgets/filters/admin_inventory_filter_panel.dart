import 'package:flutter/material.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/qr_localizations.dart';
import 'package:qr/src/presantation/widgets/filters/filter_panel.dart';

class AdminInventoryFilterPanel extends StatelessWidget {
  final AdminInventoryFilter selectedFilter;
  final ValueChanged<AdminInventoryFilter> onPressed;

  const AdminInventoryFilterPanel({
    Key key,
    @required this.selectedFilter,
    @required this.onPressed,
  })  : assert(selectedFilter != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final qrLocale = QrLocalizations.of(context);
    return FilterPanel<AdminInventoryFilter>(
      selectedFilter: selectedFilter,
      onPressed: onPressed,
      listButtons: [
        ButtonFilter<AdminInventoryFilter>(
          filter: AdminInventoryFilter.all,
          title: qrLocale.all,
          selected: selectedFilter == AdminInventoryFilter.all,
          onPressed: onPressed,
        ),
        ButtonFilter<AdminInventoryFilter>(
          filter: AdminInventoryFilter.free,
          title: qrLocale.free,
          selected: selectedFilter == AdminInventoryFilter.free,
          onPressed: onPressed,
        ),
        ButtonFilter<AdminInventoryFilter>(
          filter: AdminInventoryFilter.taken,
          title: qrLocale.taken,
          selected: selectedFilter == AdminInventoryFilter.taken,
          onPressed: onPressed,
        ),
        ButtonFilter<AdminInventoryFilter>(
          filter: AdminInventoryFilter.lost,
          title: qrLocale.lost,
          selected: selectedFilter == AdminInventoryFilter.lost,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
