import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/pages/admin_page/admin_capabilities/add_new_inventory_page.dart';
import 'package:qr/src/presantation/pages/admin_page/admin_capabilities/all_inventories_page.dart';
import 'package:qr/src/presantation/pages/admin_page/admin_capabilities/users_page.dart';
import 'package:qr/src/presantation/presenters/admin_page_presenters/admin_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';
import 'package:qr/src/presantation/widgets/title_tile.dart';

class AdminPage extends StatefulWidget {
  static const nameRoute = routes.adminCapabilities;

  static PageRoute<AdminPage> buildPageRoute() {
    return MaterialPageRoute<AdminPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminPagePresenter(),
      child: AdminPage(),
    );
  }

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final _presenter = Provider.of<AdminPagePresenter>(context);

    final _superUserListTiles = [
      TitleTile(title: qrLocale.superUserCapabilities),
      ListTile(
        leading: Icon(Icons.exposure_plus_1),
        title: Text(qrLocale.addUserToAdmins),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.exposure_neg_1),
        title: Text(qrLocale.removeUserFromAdmins),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.remove),
        title: Text(qrLocale.removeInventorStatistic),
        onTap: () {},
      ),
    ];

    final _listTiles = [
      ListTile(
        leading: Icon(Icons.people),
        title: Text(qrLocale.users),
        onTap: () => _navigateTo(UsersPage.buildPageRoute()),
      ),
      ListTile(
        leading: Icon(Icons.assignment),
        title: Text(qrLocale.allInventories),
        onTap: () => _navigateTo(AllInventoriesPage.buildPageRoute()),
      ),
      ListTile(
        leading: Icon(Icons.exposure_plus_1),
        title: Text(qrLocale.addNewInventoryToDB),
        onTap: () => _navigateTo(AddNewInventoryPage.buildPageRoute()),
      ),
      ListTile(
        leading: Icon(Icons.exposure_neg_1),
        title: Text(qrLocale.removeInventoryFromDB),
        onTap: () {},
      ),
      if (_presenter.isSuperUser) ..._superUserListTiles
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.adminCapabilities),
      ),
      drawer: QrDrawer(),
      body: ListView.separated(
          itemCount: _listTiles.length,
          itemBuilder: (context, index) {
            return _listTiles[index];
          },
          separatorBuilder: (context, index) => Divider(height: 0.0)),
    );
  }

  Future<void> _navigateTo(Route route) async {
    await Navigator.of(context).push(route);
  }
}
