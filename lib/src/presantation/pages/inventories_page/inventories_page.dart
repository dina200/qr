import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/qr_localizations.dart';
import 'package:qr/src/presantation/pages/inventory_page/inventory_page.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/presenters/inventories_page_presenter.dart';
import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';
import 'package:qr/src/presantation/widgets/filters/user_inventory_filter_panel.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';
import 'package:qr/src/utils/injector.dart';

class InventoriesPage extends StatefulWidget {
  static const nameRoute = routes.inventories;

  static PageRoute<InventoriesPage> buildPageRoute() {
    return MaterialPageRoute<InventoriesPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventoriesPagePresenter(),
      child: InventoriesPage(),
    );
  }

  final RouteObserver<PageRoute> routeObserver = injector.get<RouteObserver>();

  @override
  _InventoriesState createState() => _InventoriesState();
}

class _InventoriesState extends State<InventoriesPage> with RouteAware {
  InventoriesPagePresenter _presenter;

  QrLocalizations get qrLocale => QrLocalizations.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    _presenter.update();
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            UserInventoryFilterPanel(
              onPressed: _onPressedFilter,
              selectedFilter: _presenter.selectedFilter,
            ),
            if (inventories != null && inventories.isNotEmpty)
              _buildInventoriesList(inventories),
            if (inventories?.isEmpty ?? false) _buildInfoWidgetAboutEmptyList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoWidgetAboutEmptyList() {
    return Expanded(
      child: Center(
        child: Text(
          qrLocale.listIsEmpty,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _onPressedFilter(UserInventoryFilter filter) async {
    await _presenter.fetchInventories(filter);
  }

  Widget _buildInventoriesList(List<Inventory> inventories) {
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
    String whenTaken = '';
    if (_presenter.selectedFilter == UserInventoryFilter.taken) {
      whenTaken = '\n${inventory.statistic.last.dateFormatted}';
    }
    return ListTile(
      title: Text(inventory.name),
      subtitle: Text('${qrLocale.id} : ${inventory.id}'),
      trailing: Text(
        '${inventory.status.status}$whenTaken',
        textAlign: TextAlign.end,
      ),
      onTap: () => _openInventoryPage(inventory),
    );
  }

  void _openInventoryPage(Inventory inventory) {
    Navigator.of(context).push(InventoryPage.buildPageRoute(inventory));
  }
}
