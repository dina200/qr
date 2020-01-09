import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr/src/data/repositories_implemetations/auth_repository_impl.dart';
import 'package:qr/src/data/repositories_implemetations/user_repository_impl.dart';
import 'package:qr/src/domain/repositories_contracts/auth_repository.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/presantation/pages/admin_page/admin_settings_page.dart';
import 'package:qr/src/presantation/pages/auth_page/auth_page.dart';
import 'package:qr/src/presantation/pages/auth_page/registration_page.dart';
import 'package:qr/src/presantation/pages/empty_page/empty_page.dart';
import 'package:qr/src/presantation/pages/inventories_page/inventories_page.dart';
import 'package:qr/src/presantation/pages/qr_reader_page/qr_reader_page.dart';
import 'package:qr/src/presantation/pages/user_profile_page/user_profile_page.dart';
import 'package:qr/src/presantation/routes.dart' as Routes;
import 'package:qr/src/utils/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  injector
    ..register<AuthRepository>(AuthRepositoryImpl())
    ..register<UserRepository>(UserRepositoryFirestoreImpl());

  await injector.get<UserRepository>().init();

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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent[100],
        primaryColorDark: Colors.deepPurple[800],
      ),
      home: _handleWindowDisplay(),
      routes: <String, WidgetBuilder>{
        Routes.auth: (context) => AuthPage(),
        Routes.registration: (context) => RegistrationScreen(),
        Routes.userProfile: (context) => UserProfilePage(),
        Routes.inventories: (context) => InventoriesPage(),
        Routes.qrReader: (context) => QrReaderPage(),
        Routes.adminSettings: (context) => AdminSettingsPage(),
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
