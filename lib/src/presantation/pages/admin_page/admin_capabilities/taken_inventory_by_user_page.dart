import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/locale/qr_localizations.dart';
import 'package:qr/src/presantation/presenters/admin_page_presenters/admins_presenters/taken_inventory_by_user_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/loading_layout.dart';
import 'package:qr/src/utils/injector.dart';

class TakenInventoriesPage extends StatefulWidget {
  static const nameRoute = routes.takenInventories;

  static PageRoute<TakenInventoriesPage> buildPageRoute(User user) {
    return MaterialPageRoute<TakenInventoriesPage>(
      builder: (context) => _builder(context, user),
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context, User user) {
    return ChangeNotifierProvider(
      create: (_) => TakenInventoriesPagePresenter(user),
      child: TakenInventoriesPage(),
    );
  }

  final RouteObserver<PageRoute> routeObserver = injector.get<RouteObserver>();

  @override
  _InventoriesState createState() => _InventoriesState();
}

class _InventoriesState extends State<TakenInventoriesPage> {
  TakenInventoriesPagePresenter _presenter;

  QrLocalizations get qrLocale => QrLocalizations.of(context);

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<TakenInventoriesPagePresenter>(context);
    final inventories = _presenter.inventories;
    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.takenInventoryByUser),
      ),
      body: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: Column(
          children: <Widget>[
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
        child: Text(qrLocale.listIsEmpty),
      ),
    );
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
    String whenTaken = '\n${inventory.statistic.last.dateFormatted}';
    return ListTile(
      title: Text(inventory.name),
      subtitle: Text('${qrLocale.id} : ${inventory.id}'),
      trailing: Text(
        '${inventory.status.status}$whenTaken',
        textAlign: TextAlign.end,
      ),
    );
  }
}
