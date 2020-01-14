import 'package:flutter/material.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/domain/entities/inventory.dart';

class InventoryTable extends StatelessWidget {
  final Inventory inventory;

  const InventoryTable({Key key, @required this.inventory})
      : assert (inventory != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.top,
        border: TableBorder.all(color: Theme.of(context).dividerColor),
        columnWidths: {0: IntrinsicColumnWidth(), 1: FixedColumnWidth(200.0)},
        children: [
          _buildTableRow(qrLocale.id, inventory.id),
          _buildTableRow(
              qrLocale.name.toLowerCase(), inventory.name),
          _buildTableRow(qrLocale.description, inventory.info),
          _buildTableRow(
              qrLocale.status, '${inventory.status.status}'),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String name, String value) {
    return TableRow(
      children: [
        _buildTableRowPadding(Text(name)),
        _buildTableRowPadding(Text(value)),
      ],
    );
  }

  Widget _buildTableRowPadding(Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: child,);
  }
}
