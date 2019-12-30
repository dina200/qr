import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/pages/auth_page/auth_payload.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/auth_layout.dart';
import 'package:qr/src/presantation/widgets/social_buttons.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: AuthContainer(
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10.0,
          children: <Widget>[
            Text(
              qrLocale.appName,
              style: Theme.of(context).textTheme.title,
            ),
            SocialButton.google(
              title: qrLocale.loginWithGoogle,
              onPressed: login,
            ),
            Text(
              qrLocale.or.toLowerCase(),
              style: Theme.of(context).textTheme.subtitle,
            ),
            SocialButton.google(
              title: qrLocale.signUpViaGoogle,
              onPressed: register,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
//      final authPayload = await _googleSignIn();
      //todo: login with googleSignIn and authPayload
      Navigator.of(context).pushNamedAndRemoveUntil(
        routes.inventories,
        (_) => false,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> register() async {
    try {
      final authPayload = await _googleSignIn();
      //todo: navigate to register screen with googleSignIn and authPayload
      Navigator.of(context).pushNamed(
        routes.registration,
        arguments: authPayload,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<GooglePayload> _googleSignIn() async {
    return GooglePayload(
      'Name Surname',
      'qwe@qwe.qwe',
      '123456',
    );
  }
}
