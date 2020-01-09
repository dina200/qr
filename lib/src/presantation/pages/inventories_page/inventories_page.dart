import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/inventories_page_presenter.dart';
import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';
import 'package:qr/src/presantation/widgets/filter_panel.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';

class InventoriesPage extends StatefulWidget {
  @override
  _InventoriesState createState() => _InventoriesState();
}

class _InventoriesState extends State<InventoriesPage> {
  InventoriesPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventoriesPagePresenter(),
      child: Builder(
        builder: _buildLayout,
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    _presenter = Provider.of<InventoriesPagePresenter>(context);
    final inventories = _presenter.inventories;
    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.inventories),
      ),
      drawer: QrDrawer(),
      body: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: Column(
          children: <Widget>[
            FilterPanel(
              onPressed: _onPressedFilter,
              selectedFilter: _presenter.selectedFilter,
            ),
            if (inventories != null && inventories.isNotEmpty)
              _buildInventoriesList(inventories),
            if (inventories.isEmpty) _buildInfoWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoriesList(List<Inventory> inventories) {
    return Expanded(
      child: ListView.separated(
        itemCount: inventories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(inventories[index].name),
            subtitle: Text('${qrLocale.id} : ${inventories[index].id}'),
            trailing: Text(inventories[index].status.status),
          );
        },
        separatorBuilder: (context, index) => Divider(height: 0.0),
      ),
    );
  }

  Widget _buildInfoWidget() {
    return Expanded(
      child: Center(
        child: Text(qrLocale.noAnyInformationAboutInventories),
      ),
    );
  }

  Future<void> _onPressedFilter(InventoryFilter filter) async {
    await _presenter.fetchInventories(filter);
  }
}
