import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:qr/src/data/repositories_implemetations/auth_repository_impl.dart';
import 'package:qr/src/data/repositories_implemetations/user_repository_impl.dart';
import 'package:qr/src/domain/repositories_contracts/auth_repository.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/presantation/locale/qr_localizations.dart';
import 'package:qr/src/presantation/pages/auth_page/auth_page.dart';
import 'package:qr/src/presantation/pages/inventories_page/inventories_page.dart';
import 'package:qr/src/utils/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  injector
    ..register<RouteObserver>(RouteObserver<PageRoute>())
    ..register<AuthRepository>(AuthRepositoryImpl())
    ..register<UserRepositoryFactory>(UserRepositoryFirestoreFactory());

  await injector.get<UserRepositoryFactory>().registerUserRepository();

  final currentUser = await FirebaseAuth.instance.currentUser();

  runApp(MyApp(isLoggedIn: currentUser != null));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({Key key, this.isLoggedIn}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent[100],
        primaryColorDark: Colors.deepPurple[800],
      ),
      onGenerateRoute: _onGenerateRoute,
      navigatorObservers: [injector.get<RouteObserver>()],
      localizationsDelegates: [
        QrLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('ru'),
        Locale('uk'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if(supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    if (widget.isLoggedIn) {
      return InventoriesPage.buildPageRoute();
    }
    return AuthPage.buildPageRoute();
  }
}
