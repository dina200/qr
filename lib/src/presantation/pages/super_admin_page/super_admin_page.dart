import 'package:flutter/material.dart';

import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';

class SuperAdminPage extends StatefulWidget {
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
