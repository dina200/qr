import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:qr/src/presantation/pages/auth_page/auth_page.dart';
import 'package:qr/src/presantation/pages/auth_page/registration_page.dart';
import 'package:qr/src/presantation/pages/empty_page/empty_page.dart';
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
  final _fireBaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _handleWindowDisplay(),
      routes: <String, WidgetBuilder>{
        Routes.auth: (context) => AuthPage(),
        Routes.registration: (context) => RegistrationScreen(),
        Routes.inventories: (context) => InventoriesPage(),
        Routes.qrReader: (context) => QrReaderPage(),
      },
    );
  }

  Widget _handleWindowDisplay() {
    return StreamBuilder(
      stream: _fireBaseAuth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return EmptyPage();
        } else {
          if (snapshot.hasData) {
            return InventoriesPage();
          } else {
            return AuthPage();
          }
        }
      },
    );
  }
}
