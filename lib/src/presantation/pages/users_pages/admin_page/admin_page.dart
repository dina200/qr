import 'package:flutter/material.dart';

import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<AdminPage> {
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
