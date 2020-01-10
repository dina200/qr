import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';

class AdminSettingsPage extends StatefulWidget {
  static const nameRoute = routes.adminSettings;

  static PageRoute<AdminSettingsPage> buildPageRoute() {
    return MaterialPageRoute<AdminSettingsPage>(
      builder: _builder,
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {},
      child: AdminSettingsPage(),
    );
  }

  @override
  _AdminSettingsPageState createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.adminSettings),
      ),
      drawer: QrDrawer(),
      body: Container(),
    );
  }
}
