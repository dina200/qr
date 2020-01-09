import 'package:flutter/material.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;

class FilterPanel extends StatelessWidget {
  final InventoryFilter selectedFilter;
  final ValueChanged<InventoryFilter> onPressed;

  const FilterPanel({
    Key key,
    @required this.selectedFilter,
    @required this.onPressed,
  })  : assert(selectedFilter != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor,
            width: 1.0,
          ),
        ),
        child: Row(
          children: <Widget>[
            _ButtonFilter(
              filter: InventoryFilter.taken,
              title: qrLocale.taken,
              selected: selectedFilter == InventoryFilter.taken,
              onPressed: onPressed,
            ),
            _ButtonFilter(
              filter: InventoryFilter.history,
              title: qrLocale.history,
              selected: selectedFilter == InventoryFilter.history,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonFilter extends StatelessWidget {
  final InventoryFilter filter;
  final String title;
  final ValueChanged<InventoryFilter> onPressed;
  final bool selected;

  const _ButtonFilter({
    Key key,
    @required this.filter,
    @required this.title,
    @required this.onPressed,
    @required this.selected,
  })  : assert(filter != null),
        assert(title != null),
        assert(onPressed != null),
        assert(selected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        shape: ContinuousRectangleBorder(
          side: BorderSide(
            width: 1.0,
            color: selected ? Colors.black : Colors.transparent,
          ),
        ),
        child: Text(title),
        onPressed: () => onPressed(filter),
      ),
    );
  }
}
