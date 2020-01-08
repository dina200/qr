import 'package:flutter/material.dart';

import 'package:qr/src/presantation/widgets/drawer/qr_drawer.dart';

class UserPage extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserPage> {
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
