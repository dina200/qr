import 'package:flutter/material.dart';

import 'src/presantation/pages/inventory_page/inventory_info_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InventoryPage(),
    );
  }
}
