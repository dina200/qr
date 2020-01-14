import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/admin_page_presenters/admins_presenters/remove_inventories_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/loading_layout.dart';

class RemoveInventoriesPage extends StatefulWidget {
  static const nameRoute = routes.addNewInventory;

  static PageRoute<RemoveInventoriesPage> buildPageRoute() {
    return MaterialPageRoute<RemoveInventoriesPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RemoveInventoriesPagePresenter(),
      child: RemoveInventoriesPage(),
    );
  }

  @override
  _RemoveInventoriesPageState createState() => _RemoveInventoriesPageState();
}

class _RemoveInventoriesPageState extends State<RemoveInventoriesPage> {
  RemoveInventoriesPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<RemoveInventoriesPagePresenter>(context);
    final inventories = _presenter.inventories;

    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.removeInventoriesFromDB),
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
      child: Text(qrLocale.noAnyInventoryForRemove),
    );
  }

  Widget _buildFreeInventoriesList(List<Inventory> inventories) {
    return ListView.separated(
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
        icon: Icon(Icons.delete),
        onPressed: () async => await _onDeleteInventory(inventory),
      ),
    );
  }

  Future<void> _onDeleteInventory(Inventory inventory) async {
    final isConfirmed = await _showChoiceRemoveDialog(inventory);

    if (isConfirmed) {
      await _presenter.removeInventory(inventory.id);
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
        text: qrLocale.areYouSureWantToRemoveInventory,
        style: Theme.of(context).textTheme.subtitle,
        children: [
          TextSpan(
            text: '\n\n${qrLocale.id} : ${inventory.id}\n${qrLocale.name} : ${inventory.name}\n${qrLocale.description} : ${inventory.info}',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
