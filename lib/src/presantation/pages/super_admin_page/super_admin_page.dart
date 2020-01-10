import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';
import 'package:qr/src/presantation/routes.dart' as routes;

class SuperAdminPage extends StatefulWidget {
  static const nameRoute = routes.superAdminSettings;

  static PageRoute<SuperAdminPage> buildPageRoute() {
    return MaterialPageRoute<SuperAdminPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {},
      child: SuperAdminPage(),
    );
  }

  @override
  _SuperAdminState createState() => _SuperAdminState();
}

class _SuperAdminState extends State<SuperAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      drawer: QrDrawer(),
      body: Container(),
    );
  }
}
