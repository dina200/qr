import 'package:flutter/material.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/widgets/qr_drawer.dart';

class InventoriesPage extends StatefulWidget {
  @override
  _InventoriesState createState() => _InventoriesState();
}

class _InventoriesState extends State<InventoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(qrLocale.inventories),
      ),
      drawer: QrDrawer(),
      body: Container(),
    );
  }
}
