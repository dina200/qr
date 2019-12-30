import 'package:flutter/material.dart';

import 'package:qr/src/presantation/pages/auth_page/auth_page.dart';
import 'package:qr/src/presantation/pages/auth_page/registration_page.dart';
import 'package:qr/src/presantation/pages/inventories_page/inventories_page.dart';
import 'package:qr/src/presantation/pages/qr_reader_page/qr_reader_page.dart';
import 'package:qr/src/presantation/routes.dart' as Routes;

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
      initialRoute: Routes.auth, // if sign in => InventoriesPage()
      routes: <String, WidgetBuilder>{
        Routes.inventories: (context) => InventoriesPage(),
        Routes.qrReader: (context) => QrReaderPage(),
        Routes.auth: (context) => AuthPage(),
        Routes.registration: (context) => RegistrationScreen(),
      },
    );
  }
}
