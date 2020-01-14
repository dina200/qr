import 'package:flutter/material.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/widgets/filters/filter_panel.dart';

class UsersFilterPanel extends StatelessWidget {
  final UserFilter selectedFilter;
  final ValueChanged<UserFilter> onPressed;

  const UsersFilterPanel({
    Key key,
    @required this.selectedFilter,
    @required this.onPressed,
  })  : assert(selectedFilter != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterPanel<UserFilter>(
      selectedFilter: selectedFilter,
      onPressed: onPressed,
      listButtons: [
        ButtonFilter<UserFilter>(
          filter: UserFilter.all,
          title: qrLocale.all,
          selected: selectedFilter == UserFilter.all,
          onPressed: onPressed,
        ),
        ButtonFilter<UserFilter>(
          filter: UserFilter.users,
          title: qrLocale.users,
          selected: selectedFilter == UserFilter.users,
          onPressed: onPressed,
        ),
        ButtonFilter<UserFilter>(
          filter: UserFilter.admins,
          title: qrLocale.admins,
          selected: selectedFilter == UserFilter.admins,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
