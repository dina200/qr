import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/admin_page_presenters/admins_presenters/add_new_inventory_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;

class AddNewInventoryPage extends StatefulWidget {
  static const nameRoute = routes.addNewInventory;

  static PageRoute<AddNewInventoryPage> buildPageRoute() {
    return MaterialPageRoute<AddNewInventoryPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddNewInventoryPagePresenter(),
      child: AddNewInventoryPage(),
    );
  }

  @override
  _AddNewInventoryPageState createState() => _AddNewInventoryPageState();
}

class _AddNewInventoryPageState extends State<AddNewInventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.addNewInventoryToDB),
      ),
    );
  }
}
