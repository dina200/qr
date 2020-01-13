import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/admin_page_presenters/admins_presenters/remove_inventories_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;

//todo: RemoveInventoryPage implementation
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
    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.removeInventoriesFromDB),
      ),
    );
  }
}
