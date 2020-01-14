import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/pages/admin_page/admin_capabilities/admin_inventory_page.dart';
import 'package:qr/src/presantation/presenters/admin_page_presenters/admins_presenters/all_inventories_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/widgets/filters/admin_inventory_filter_panel.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';

class AllInventoriesPage extends StatefulWidget {
  static const nameRoute = routes.allInventories;

  static PageRoute<AllInventoriesPage> buildPageRoute() {
    return MaterialPageRoute<AllInventoriesPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AllInventoriesPagePresenter(),
      child: AllInventoriesPage(),
    );
  }

  @override
  _AllInventoriesState createState() => _AllInventoriesState();
}

class _AllInventoriesState extends State<AllInventoriesPage> {
  AllInventoriesPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<AllInventoriesPagePresenter>(context);
    final inventories = _presenter.inventories;
    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.allInventories),
      ),
      body: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: Column(
          children: <Widget>[
            AdminInventoryFilterPanel(
              onPressed: _onPressedFilter,
              selectedFilter: _presenter.selectedFilter,
            ),
            _buildBody(inventories),
          ],
        ),
      ),
    );
  }

  void _onPressedFilter(AdminInventoryFilter filter) {
    _presenter.fetchInventories(filter);
  }

  Widget _buildBody(List<Inventory> inventories) {
    if (inventories != null && inventories.isNotEmpty)
      return _buildAllInventoriesList(inventories);
    else if (inventories?.isEmpty ?? false)
      return _buildInfoWidgetAboutEmptyList();
    else
      return SizedBox();
  }

  Widget _buildAllInventoriesList(List<Inventory> inventories) {
    return Expanded(
      child: ListView.separated(
        itemCount: inventories.length,
        itemBuilder: (context, index) {
          return _buildTile(inventories[index]);
        },
        separatorBuilder: (context, index) => Divider(height: 0.0),
      ),
    );
  }

  Widget _buildTile(Inventory inventory) {
    return ListTile(
      title: Text(inventory.name),
      subtitle: Text('${qrLocale.id} : ${inventory.id}'),
      trailing: Text(
        '${inventory.status.status}',
        textAlign: TextAlign.end,
      ),
      onTap: () => _openInventoryPage(inventory),
    );
  }

  void _openInventoryPage(Inventory inventory) {
    Navigator.of(context).push(AdminInventoryPage.buildPageRoute(inventory));
  }

  Widget _buildInfoWidgetAboutEmptyList() {
    return Expanded(
      child: Center(
        child: Text(qrLocale.listIsEmpty),
      ),
    );
  }
}
