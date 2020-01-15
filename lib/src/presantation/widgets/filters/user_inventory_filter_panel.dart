import 'package:flutter/material.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/widgets/filters/filter_panel.dart';

class UserInventoryFilterPanel extends StatelessWidget {
  final UserInventoryFilter selectedFilter;
  final ValueChanged<UserInventoryFilter> onPressed;

  const UserInventoryFilterPanel({
    Key key,
    @required this.selectedFilter,
    @required this.onPressed,
  })  : assert(selectedFilter != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterPanel<UserInventoryFilter>(
      selectedFilter: selectedFilter,
      onPressed: onPressed,
      listButtons: [
        ButtonFilter<UserInventoryFilter>(
          filter: UserInventoryFilter.taken,
          title: qrLocale.taken,
          selected: selectedFilter == UserInventoryFilter.taken,
          onPressed: onPressed,
        ),
        ButtonFilter<UserInventoryFilter>(
          filter: UserInventoryFilter.lost,
          title: qrLocale.lost,
          selected: selectedFilter == UserInventoryFilter.lost,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
