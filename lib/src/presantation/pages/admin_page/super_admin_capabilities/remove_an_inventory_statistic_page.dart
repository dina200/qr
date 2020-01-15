import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/admin_page_presenters/super_admins_presenters/remove_an_inventory_statistic_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/loading_layout.dart';

class RemoveInventoriesStatisticPage extends StatefulWidget {
  static const nameRoute = routes.removeInventoriesStatistic;

  static PageRoute<RemoveInventoriesStatisticPage> buildPageRoute() {
    return MaterialPageRoute<RemoveInventoriesStatisticPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RemoveInventoriesStatisticPagePresenter(),
      child: RemoveInventoriesStatisticPage(),
    );
  }

  @override
  _RemoveInventoriesStatisticPageState createState() => _RemoveInventoriesStatisticPageState();
}

class _RemoveInventoriesStatisticPageState extends State<RemoveInventoriesStatisticPage> {
  RemoveInventoriesStatisticPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<RemoveInventoriesStatisticPagePresenter>(context);
    final inventories = _presenter.inventories;

    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.removeInventoryStatistic),
      ),
      body: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: _buildBody(inventories),
      ),
    );
  }

  Widget _buildBody(List<Inventory> inventories) {
    if (inventories != null && inventories.isNotEmpty)
      return _buildFreeInventoriesList(inventories);
    else if (inventories?.isEmpty ?? false)
      return _buildInfoWidgetAboutEmptyList();
    else
      return SizedBox();
  }

  Widget _buildInfoWidgetAboutEmptyList() {
    return Center(
      child: Text(qrLocale.noAnyInventoryForRemovingStatistic),
    );
  }

  Widget _buildFreeInventoriesList(List<Inventory> inventories) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 16.0),
      itemCount: inventories.length,
      itemBuilder: (context, index) {
        return _buildTile(inventories[index]);
      },
      separatorBuilder: (context, index) => Divider(height: 0.0),
    );
  }

  Widget _buildTile(Inventory inventory) {
    return ListTile(
      title: Text(inventory.name),
      subtitle: Text('${qrLocale.id} : ${inventory.id}'),
      trailing: IconButton(
        icon: Icon(Icons.delete_sweep),
        onPressed: () async => await _onDeleteInventoryStatistic(inventory),
      ),
    );
  }

  Future<void> _onDeleteInventoryStatistic(Inventory inventory) async {
    final isConfirmed = await _showChoiceRemoveDialog(inventory);

    if (isConfirmed) {
      await _presenter.removeInventoryStatistic(inventory.id);
    }
  }

  Future<bool> _showChoiceRemoveDialog(Inventory inventory) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: _buildDialogTitle(inventory),
          actions: <Widget>[
            FlatButton(
              child: Text(qrLocale.cancel),
              onPressed: () => Navigator.of(context).pop<bool>(false),
            ),
            FlatButton(
              child: Text(qrLocale.ok),
              onPressed: () => Navigator.of(context).pop<bool>(true),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  Widget _buildDialogTitle(Inventory inventory) {
    return RichText(
      text: TextSpan(
        text: qrLocale.areYouSureWantToRemoveInventoryStatistic,
        style: Theme.of(context).textTheme.subtitle,
        children: [
          TextSpan(
            text: '\n\n${qrLocale.id} : ${inventory.id}\n${qrLocale.name.toLowerCase()} : ${inventory.name}\n${qrLocale.description} : ${inventory.info}',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
